import 'package:bobwords/common/model/english_word.dart';
import 'package:bobwords/common/text_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../db_helper.dart';
import '../../memo/lake_notifier.dart';

class NotSureButton extends StatefulWidget {
  const NotSureButton(this.word, this.usage, {Key? key}) : super(key: key);

  /// -1 忘记了 0 模糊
  final int usage;
  final EnglishWord word;

  @override
  State<NotSureButton> createState() => _NotSureButtonState();
}

class _NotSureButtonState extends State<NotSureButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<LakeModel>().learnWordBad(0, widget.word.simpleWord!);
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(10.w, 4.w, 10.w, 4.w),
        padding: EdgeInsets.fromLTRB(4.w, 6.w, 4.w, 4.w),
        height: 40.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.r))),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Text(widget.usage == -1 ? '忘记了' : '模糊',
              style: TextUtil.base.w400.white.sp(14)),
          Container(
              height: 4.w,
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                  color:
                      widget.usage == -1 ? Colors.red[900] : Colors.amber[800],
                  borderRadius: BorderRadius.all(Radius.circular(3.w))))
        ]),
      ),
    );
  }
}

class SureButton extends StatefulWidget {
  const SureButton(
      this.word, this.accomplished, this.allToAccomplish,
      {required this.onTap, this.text, Key? key})
      : super(key: key);

  final int accomplished, allToAccomplish;
  final EnglishWord word;
  final String? text;
  final Function(TapUpDetails) onTap;

  @override
  State<SureButton> createState() => _SureButtonState();
}

class _SureButtonState extends State<SureButton> {
  bool withAnimate = true;

  Widget greenInd = Expanded(
      child: Container(
          height: 4.w,
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          decoration: BoxDecoration(
              color: Colors.green[800],
              borderRadius: BorderRadius.all(Radius.circular(3.w)))));
  Widget greenSpaceInd = Expanded(
      child: Container(
    height: 4.w,
    margin: EdgeInsets.symmetric(horizontal: 2.w),
    decoration: BoxDecoration(
        border: Border.all(color: Colors.green[800]!),
        borderRadius: BorderRadius.all(Radius.circular(3.w))),
  ));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
          withAnimate = false;
      },
      onTapUp: widget.onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(10.w, 4.w, 10.w, 4.w),
        padding: EdgeInsets.fromLTRB(4.w, 6.w, 4.w, 4.w),
        height: 40.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            color: Colors.transparent),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Text(widget.text ?? '认识', style: TextUtil.base.w400.white.sp(13.8)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List<Widget>.generate(widget.allToAccomplish, (index) {
                if (index == widget.accomplished && withAnimate) {
                  return const FlashingIndicator();
                } else if (index <= widget.accomplished) {
                  return greenInd;
                } else {
                  return greenSpaceInd;
                }
              }),
            ),
          )
        ]),
      ),
    );
  }
}

class FlashingIndicator extends StatefulWidget {
  const FlashingIndicator({Key? key}) : super(key: key);

  @override
  State<FlashingIndicator> createState() => _FlashingIndicatorState();
}

class _FlashingIndicatorState extends State<FlashingIndicator> {
  late bool on;

  @override
  void initState() {
    on = false;
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000))
        .whenComplete(() => setState(() {
              on = true;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: AnimatedContainer(
      height: 4.w,
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
          color: on ? Colors.greenAccent[700] : Colors.transparent,
          border: Border.all(
              color: on ? Colors.greenAccent[700]! : Colors.green[800]!),
          borderRadius: BorderRadius.all(Radius.circular(3.w))),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOutQuad,
      onEnd: () => setState(() {
        on = !on;
      }),
    ));
  }
}
