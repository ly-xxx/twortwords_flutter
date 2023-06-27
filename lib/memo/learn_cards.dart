import 'package:bobwords/common/basic_widgets/buttons.dart';
import 'package:bobwords/common/basic_widgets/word_widgets.dart';
import 'package:bobwords/common/fade_and_offstage.dart';
import 'package:bobwords/common/model/english_word.dart';
import 'package:bobwords/common/word_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../common/text_util.dart';
import 'keyboard.dart';
import 'lake_notifier.dart';

class FirstLearnCard extends StatefulWidget {
  const FirstLearnCard(this.word, {Key? key}) : super(key: key);

  final EnglishWord word;

  @override
  State<FirstLearnCard> createState() => _FirstLearnCardState();
}

class _FirstLearnCardState extends State<FirstLearnCard> {
  bool showDef = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.sh - MediaQuery.of(context).padding.top - 120.h,
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
          if (!showDef) ...[
            BasicPhonetic(widget.word.phonetic,
                word: widget.word.word, read: false),
            const Spacer()
          ],
          if (showDef) Expanded(child: WordStatus(widget.word)),
          Row(children: [
            Expanded(
                child: SureButton(onTap: (_) {
              if (showDef == false) {
                setState(() {
                  showDef = true;
                });
              } else {
                context
                    .read<LakeModel>()
                    .learnNewWordGood(0, simpleWord: widget.word.simpleWord!);
              }
            }, widget.word, 0, 4)),
            Expanded(child: NotSureButton(widget.word, -1))
          ])
        ],
      ),
    );
  }
}

class FirstLearnRw1Card extends StatefulWidget {
  const FirstLearnRw1Card(this.word, {Key? key}) : super(key: key);

  final EnglishWord word;

  @override
  State<FirstLearnRw1Card> createState() => _FirstLearnRw1CardState();
}

class _FirstLearnRw1CardState extends State<FirstLearnRw1Card> {
  bool showDef = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.sh - MediaQuery.of(context).padding.top - 120.h,
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
          if (!showDef) ...[
            BasicPhonetic(widget.word.phonetic,
                word: widget.word.word, read: false),
            const Spacer()
          ],
          if (showDef) Expanded(child: WordStatus(widget.word)),
          Row(children: [
            Expanded(
                child: SureButton(onTap: (_) {
              if (showDef == false) {
                setState(() {
                  showDef = true;
                });
              } else {
                context
                    .read<LakeModel>()
                    .learnBlindWordGood(0, simpleWord: widget.word.simpleWord!);
              }
            }, widget.word, 1, 4)),
            Expanded(child: NotSureButton(widget.word, -1))
          ])
        ],
      ),
    );
  }
}

class FirstLearnSpell1Card extends StatefulWidget {
  const FirstLearnSpell1Card(this.word, {Key? key}) : super(key: key);

  final EnglishWord word;

  @override
  State<FirstLearnSpell1Card> createState() => _FirstLearnSpell1CardState();
}

class _FirstLearnSpell1CardState extends State<FirstLearnSpell1Card> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.sh - MediaQuery.of(context).padding.top - 120.h,
      width: 1.sw - 20.w,
      margin: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.w),
      padding: EdgeInsets.fromLTRB(12.w, 6.w, 4.w, 4.w),
      decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.all(Radius.circular(10.r))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: BeautifulKeyboard(
              width: 1.sw - 20.w,
              correctAnswer: widget.word,
              showHint: true,
            ),
          ),
        ],
      ),
    );
  }
}

class FirstLearnSpell2Card extends StatefulWidget {
  const FirstLearnSpell2Card(this.word, {Key? key}) : super(key: key);

  final EnglishWord word;

  @override
  State<FirstLearnSpell2Card> createState() => _FirstLearnSpell2CardState();
}

class _FirstLearnSpell2CardState extends State<FirstLearnSpell2Card> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.sh - MediaQuery.of(context).padding.top - 120.h,
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
            Expanded(
                child: SureButton(
              widget.word,
              3,
              4,
              onTap: (_) {
                context.read<LakeModel>().learnBlindSpellWordGood(0,
                    simpleWord: widget.word.simpleWord!);
              },
            )),
            Expanded(child: NotSureButton(widget.word, -1))
          ])
        ],
      ),
    );
  }
}

class SpaceCard extends StatefulWidget {
  const SpaceCard({Key? key}) : super(key: key);

  @override
  State<SpaceCard> createState() => _SpaceCardState();
}

class _SpaceCardState extends State<SpaceCard> {
  bool showDef = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.sh - MediaQuery.of(context).padding.top - 120.h,
      width: 1.sw - 20.w,
      margin: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.w),
      padding: EdgeInsets.fromLTRB(12.w, 6.w, 4.w, 4.w),
      decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.all(Radius.circular(10.r))),
    );
  }
}

class WordStatus extends StatelessWidget {
  const WordStatus(this.word, {Key? key}) : super(key: key);
  final EnglishWord word;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 26.h,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            BasicPhonetic(word.phonetic, word: word.word),
            if ((word.tag) != 'null' && (word.tag) != '') WordTag(word.tag)
          ],
        ),
      ),
      SizedBox(height: 10.h),
      Padding(
          padding: EdgeInsets.only(left: 5.h, bottom: 4.h),
          child: Text(word.translation, style: TextUtil.base.white.w400)),
      if (word.definition != 'null' && word.definition != '')
        Padding(
            padding: EdgeInsets.only(left: 5.h, bottom: 4.h),
            child: Text(word.definition, style: TextUtil.base.white.w200)),
      if (word.exchange != 'null' && word.exchange != '')
        Padding(
            padding: EdgeInsets.only(left: 5.h, top: 8.h, bottom: 4.h),
            child: Text(
                word.exchange.replaceAll('/', '  ').replaceAll(':', ': '),
                style: TextUtil.base.white.w600)),
      // Text(widget.englishWord.collins, style: TextUtil.base.white.w300),
      // Text(widget.englishWord.oxford, style: TextUtil.base.white.w300),
      SizedBox(height: 4.h),
    ]));
  }
}
