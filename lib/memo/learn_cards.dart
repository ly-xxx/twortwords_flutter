import 'package:bobwords/common/basic_widgets/buttons.dart';
import 'package:bobwords/common/basic_widgets/word_widgets.dart';
import 'package:bobwords/common/model/english_word.dart';
import 'package:bobwords/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'lake_notifier.dart';

class FirstLearnCard extends StatefulWidget {
  const FirstLearnCard(this.word, {Key? key}) : super(key: key);

  final EnglishWord word;

  @override
  State<FirstLearnCard> createState() => _FirstLearnCardState();
}

class _FirstLearnCardState extends State<FirstLearnCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.2.sw,
      width: 1.sw - 20.w,
      margin: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.w),
      padding: EdgeInsets.fromLTRB(12.w, 6.w, 4.w, 4.w),
      decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.all(Radius.circular(10.r))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BasicBigWord(widget.word.word, leftAlign: true),
          BasicPhonetic(widget.word.phonetic, word: widget.word.word),
          const Spacer(),
          Row(children: [
            Expanded(child: SureButton(widget.word, 0, 4, 0)),
            Expanded(child: NotSureButton(widget.word, -1))
          ])
        ],
      ),
    );
  }
}

class FirstLearnRw1Card extends StatefulWidget {
  const FirstLearnRw1Card({Key? key}) : super(key: key);

  @override
  State<FirstLearnRw1Card> createState() => _FirstLearnRw1CardState();
}

class _FirstLearnRw1CardState extends State<FirstLearnRw1Card> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class FirstLearnRw2Card extends StatefulWidget {
  const FirstLearnRw2Card({Key? key}) : super(key: key);

  @override
  State<FirstLearnRw2Card> createState() => _FirstLearnRw2CardState();
}

class _FirstLearnRw2CardState extends State<FirstLearnRw2Card> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class FirstLearnRw3Card extends StatefulWidget {
  const FirstLearnRw3Card({Key? key}) : super(key: key);

  @override
  State<FirstLearnRw3Card> createState() => _FirstLearnRw3CardState();
}

class _FirstLearnRw3CardState extends State<FirstLearnRw3Card> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
