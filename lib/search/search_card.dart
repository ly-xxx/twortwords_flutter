import 'dart:async';
import 'dart:ui';

import 'package:bobwords/common/fade_and_offstage.dart';
import 'package:bobwords/common/text_util.dart';
import 'package:bobwords/search/widgets/static_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../common/model/english_word.dart';
import '../db_helper.dart';

class SearchCard extends StatefulWidget {
  SearchCard(this.focusNode, {Key? key}) : super(key: key);

  FocusNode focusNode = FocusNode();

  @override
  State<SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> with WidgetsBindingObserver {
  List<EnglishWord> wordList = [];

  bool showOCR = false;

  int wordQueryOffset = 0;

  double keyboardHeight = 0;

  bool showWords = false;

  TextEditingController textEditingController = TextEditingController();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 初始化
    WidgetsBinding.instance.addObserver(this);
  }

  String text = "";
  final StreamController<String> controller = StreamController<String>();

  void setText(value) {
    controller.add(value);
  }

  @override
  void dispose() {
    // 销毁
    controller.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 监听
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (MediaQuery.of(context).viewInsets.bottom == 0) {
          setState(() {
            keyboardHeight = 0;
          });
        } else {
          setState(() {
            keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(6.h, 6.h, 6.h, 4.h),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                  child: Container(
                    height: 30.h,
                    padding: EdgeInsets.only(left: 6.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: Colors.grey.shade200.withOpacity(0.7)),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                          focusNode: widget.focusNode,
                          keyboardType: TextInputType.emailAddress,
                          style: TextUtil.base.w800.deeperGrey.sp(18),
                          showCursor: false,
                          maxLines: 1,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              labelStyle: TextUtil.base.opaGrey.w900),
                          controller: textEditingController,
                          onChanged: (str) => setState(() {
                            wordQueryOffset = 0;
                            scrollController.animateTo(0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOutCirc);
                            if (str != '') {
                              wordList = DictionaryDataBaseHelper()
                                  .searchAll(textEditingController.text, 0);
                              showWords = true;
                            } else {
                              showWords = false;
                            }
                          }),
                        )),
                        GestureDetector(
                          onTap: () {
                            textEditingController.clear();
                            setState(() {
                              showWords = false;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(7.5),
                            child: SvgPicture.asset(
                              'assets/svg/x.svg',
                              color: Colors.black54,
                              width: 15.h,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))),
        ),
        FadeAndOffstage(
          show: showWords,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
              child: AnimatedContainer(
                height: 1.sh -
                    112.h -
                    MediaQuery.of(context).padding.top -
                    keyboardHeight,
                margin: EdgeInsets.fromLTRB(6.h, 0, 6.h, 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.grey.shade200.withOpacity(0.56)),
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(children: [
                    ...List.generate(
                        wordList.length,
                        (index) => SizedBox(
                              height: 36,
                              child: SimpleItem(wordList[index]),
                            )),
                    if (wordList.length >= 50)
                      GestureDetector(
                          child: Container(
                              height: 50.h, width: 1.sw, color: Colors.white24),
                          onTap: () {
                            setState(() {
                              wordQueryOffset += 50;
                              wordList += DictionaryDataBaseHelper().searchAll(
                                  textEditingController.text, wordQueryOffset);
                            });
                          })
                  ]),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
