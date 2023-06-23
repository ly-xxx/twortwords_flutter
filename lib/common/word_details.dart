import 'package:bobwords/common/background_container.dart';
import 'package:bobwords/common/basic_widgets/word_widgets.dart';
import 'package:bobwords/common/text_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'model/english_word.dart';

class WordDetails extends StatefulWidget {
  WordDetails(this.englishWord, {Key? key}) : super(key: key);

  EnglishWord englishWord;

  @override
  State<WordDetails> createState() => _WordDetailsState();
}

class _WordDetailsState extends State<WordDetails> {
  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      opacity: 0.1,
      child: SafeArea(
          child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.fromLTRB(12.h, 12.h, 10.h, 4.h),
          child: ListView(children: [
            Text(
                '#${widget.englishWord.id}${(widget.englishWord.bncSeq ?? 'null') != 'null' && (widget.englishWord.bncSeq ?? 'null') != '0' ? '  BNC: ${widget.englishWord.bncSeq}' : ''}${(widget.englishWord.frqSeq ?? 'null') != 'null' && (widget.englishWord.frqSeq ?? 'null') != '0' ? '  FRQ: ${widget.englishWord.frqSeq}' : ''}',
                style: TextUtil.base.opaGrey.italic.w900),
            BasicBigWord(widget.englishWord.word,
                leftAlign: true,
                withPieChart: true,
                pieChartSrc: widget.englishWord.pos),
            SizedBox(height: 4.h),
            SizedBox(
              height: 26.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  BasicPhonetic(widget.englishWord.phonetic,
                      word: widget.englishWord.word),
                  if ((widget.englishWord.tag) != 'null' &&
                      (widget.englishWord.tag) != '')
                    WordTag(widget.englishWord.tag)
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
                padding: EdgeInsets.only(left: 5.h, bottom: 4.h),
                child: Text(widget.englishWord.translation,
                    style: TextUtil.base.white.w400)),
            if (widget.englishWord.definition != 'null' &&
                widget.englishWord.definition != '')
              Padding(
                  padding: EdgeInsets.only(left: 5.h, bottom: 4.h),
                  child: Text(widget.englishWord.definition,
                      style: TextUtil.base.white.w200)),
            if (widget.englishWord.exchange != 'null' &&
                widget.englishWord.exchange != '')
              Padding(
                  padding: EdgeInsets.only(left: 5.h, top: 8.h, bottom: 4.h),
                  child: Text(
                      widget.englishWord.exchange
                          .replaceAll('/', '  ')
                          .replaceAll(':', ': '),
                      style: TextUtil.base.white.w600)),
            // Text(widget.englishWord.collins, style: TextUtil.base.white.w300),
            // Text(widget.englishWord.oxford, style: TextUtil.base.white.w300),
            SizedBox(height: 4.h),
          ]),
        ),
      )),
    );
  }
}
