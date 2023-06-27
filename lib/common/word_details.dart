import 'package:bobwords/common/background_container.dart';
import 'package:bobwords/common/text_util.dart';
import 'package:bobwords/memo/keyboard.dart';
import 'package:bobwords/memo/learn_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'basic_widgets/word_widgets.dart';
import 'model/english_word.dart';

class WordDetails extends StatefulWidget {
  const WordDetails(this.englishWord, {Key? key}) : super(key: key);

  final EnglishWord englishWord;

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
            child: ListView(
              children: [
                Text(
                    '#${widget.englishWord.id}${(widget.englishWord.bncSeq ?? 'null') != 'null' && (widget.englishWord.bncSeq ?? 'null') != '0' ? '  BNC: ${widget.englishWord.bncSeq}' : ''}${(widget.englishWord.frqSeq ?? 'null') != 'null' && (widget.englishWord.frqSeq ?? 'null') != '0' ? '  FRQ: ${widget.englishWord.frqSeq}' : ''}',
                    style: TextUtil.base.opaGrey.italic.w900),
                BasicBigWord(widget.englishWord.word,
                    leftAlign: true,
                    withPieChart: true,
                    pieChartSrc: widget.englishWord.pos),
                SizedBox(height: 4.h),
                SizedBox(height: 10.h),
                WordStatus(widget.englishWord),
              ],
            ),
          ),
        )));
  }
}
