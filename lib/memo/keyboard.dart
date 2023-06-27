import 'package:bobwords/common/basic_widgets/word_widgets.dart';
import 'package:bobwords/common/fade_and_offstage.dart';
import 'package:bobwords/common/text_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../common/basic_widgets/buttons.dart';
import '../common/model/english_word.dart';
import '../db_helper.dart';
import 'lake_notifier.dart';

class BeautifulKeyboard extends StatefulWidget {
  const BeautifulKeyboard(
      {required this.width,
      required this.correctAnswer,
      Key? key,
      required this.showHint})
      : super(key: key);

  final bool showHint;
  final double width;
  final EnglishWord correctAnswer;

  @override
  State<BeautifulKeyboard> createState() => _BeautifulKeyboardState();
}

class _BeautifulKeyboardState extends State<BeautifulKeyboard> {
  final double _horizontalPadding = 10.w;
  late double _singleElementWidth;
  String text = '';
  EnglishWord minLengthWord = EnglishWord(
      id: -1,
      word: '',
      sw: '',
      phonetic: '',
      definition: '',
      translation: '',
      pos: '',
      tag: '',
      collins: '',
      oxford: '',
      bncSeq: '',
      frqSeq: '',
      exchange: '');

  late Map<String, bool> available;

  late List<String> rw1;
  late List<String> rw2;
  late List<String> rw3;
  late List<EnglishWord> wordList;

  bool finished = false;
  bool paired = false;
  bool showPhonetic = false;
  int similarity = -1;

  @override
  void initState() {
    wordList = [];
    text = '';
    rw1 = ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'];
    rw2 = ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'];
    rw3 = ['z', 'x', 'c', 'v', 'b', 'n', 'm'];
    available = {
      'q': true,
      'w': true,
      'e': true,
      'r': true,
      't': true,
      'y': true,
      'u': true,
      'i': true,
      'o': true,
      'p': true,
      'a': true,
      's': true,
      'd': true,
      'f': true,
      'g': true,
      'h': true,
      'j': true,
      'k': true,
      'l': true,
      'z': true,
      'x': true,
      'c': true,
      'v': true,
      'b': true,
      'n': true,
      'm': true,
    };
    super.initState();
  }

  onTapEle(String ele) {
    return () {
      print(ele);
      if (ele == '←') {
        text = text.substring(0, text.length - 1);
        minLengthWord.word = '';
        minLengthWord.translation = '';
      } else {
        text += ele;
      }
      RegExp regExp = RegExp('[^a-zA-Z]');
      String swText = text.replaceAllMapped(regExp, (_) => '');
      List<String> firstAlphas = [];
      if (swText == widget.correctAnswer.sw) {
        paired = true;
      } else {
        paired = false;
      }
      if (swText != '') {
        wordList =
            DictionaryDataBaseHelper().searchAll(swText, 0, pageSize: 100);
        if (wordList.isNotEmpty) {
          minLengthWord = wordList.first;
        }
        if (wordList.length < 50) {
          firstAlphas.clear();
          for (var element in wordList) {
            if (element.word.length < minLengthWord.word.length) {
              minLengthWord = element;
            }
            if (element.sw.length > swText.length) {
              firstAlphas
                  .add(element.sw.substring(swText.length, swText.length + 1));
            }
          }
        }
        similarity = levenshtein(minLengthWord.sw, widget.correctAnswer.sw);
        print(similarity);
        if (firstAlphas.isNotEmpty) {
          available.updateAll(
              (key, value) => firstAlphas.contains(key) ? true : false);
        } else {
          available.updateAll(
              (key, value) => text.isEmpty ? true : wordList.length > 2);
        }
      }
      setState(() {});
    };
  }

  deleteAll() {
    return () {
      text = '';
      minLengthWord.word = '';
      minLengthWord.translation = '';
      available.updateAll((key, value) => true);
      setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    _singleElementWidth = (widget.width - 2 * _horizontalPadding) / 10;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: widget.width * 0.2),
        BasicBigWord(text),
        Container(
            margin: EdgeInsets.only(right: _horizontalPadding, bottom: 12.h),
            color: Colors.white70,
            height: 1),
        Center(
          child: Text(widget.correctAnswer.translation,
              style: TextUtil.base.w400.white.sp(13), maxLines: 3),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () => setState(() => showPhonetic = !showPhonetic),
          child: Row(
            children: [
              const Spacer(),
              Container(
                height: 26.h,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.all(Radius.circular(10.r))),
                child: Row(
                  children: [
                    const Text('✋'),
                    if (showPhonetic)
                      BasicPhonetic(widget.correctAnswer.phonetic,
                          word: widget.correctAnswer.word),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
        const Spacer(flex: 3),
        SizedBox(height: 6.w),
        Container(
          margin: EdgeInsets.only(right: 8.w),
          height: 50.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.r))),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: similarity >= widget.correctAnswer.sw.length / 2
                    ? ((widget.width - 2 * _horizontalPadding) /
                        (similarity + 1))
                    : ((widget.width - 2 * _horizontalPadding) *
                        (widget.correctAnswer.sw.length / 2 - similarity) /
                        widget.correctAnswer.sw.length *
                        2),
                height: 50.h,
                decoration: BoxDecoration(
                    color: minLengthWord.word.isEmpty
                        ? Colors.transparent
                        : paired
                            ? Colors.green.withOpacity(0.2)
                            : Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.all(Radius.circular(10.r))),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth:
                            (widget.width - 2 * _horizontalPadding) * 0.4),
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: Text(minLengthWord.word,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextUtil.base.white.w600.sp(14)),
                    )),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: (widget.width - 2 * _horizontalPadding) * 0.6),
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Text(minLengthWord.translation,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextUtil.base.white.w300.sp(11)),
                  ),
                ),
              ),
              SizedBox(width: _horizontalPadding)
            ],
          ),
        ),
        SizedBox(height: 12.w),
        Row(
          children: List.generate(
              10,
              (index) => SizedBox(
                    width: _singleElementWidth,
                    height: _singleElementWidth * 1.3,
                    child: KeyboardElement(
                        rw1[index], available[rw1[index]] ?? false,
                        onTap: onTapEle(rw1[index])),
                  )),
        ),
        Padding(
          padding: EdgeInsets.only(left: 0.4 * _singleElementWidth),
          child: Row(
            children: List.generate(
                9,
                (index) => SizedBox(
                      width: _singleElementWidth,
                      height: _singleElementWidth * 1.3,
                      child: KeyboardElement(
                          rw2[index], available[rw2[index]] ?? false,
                          onTap: onTapEle(rw2[index])),
                    )),
          ),
        ),
        Row(
          children: [
            SizedBox(
                width: _singleElementWidth * 0.8,
                height: _singleElementWidth * 1.3,
                child: KeyboardElement('↑', false, onTap: () {})),
            ...List.generate(
                7,
                (index) => SizedBox(
                      width: _singleElementWidth,
                      height: _singleElementWidth * 1.3,
                      child: GestureDetector(
                        onTap: onTapEle(rw3[index]),
                        child: KeyboardElement(
                            rw3[index], available[rw3[index]] ?? false,
                            onTap: onTapEle(rw3[index])),
                      ),
                    )),
            SizedBox(
                width: _singleElementWidth * 2.2,
                height: _singleElementWidth * 1.3,
                child: KeyboardElement('←', true,
                    onTap: onTapEle('←'), onLongTap: deleteAll()))
          ],
        ),
        Row(
          children: [
            SizedBox(
                width: _singleElementWidth * 1.2,
                height: _singleElementWidth,
                child: KeyboardElement(' ', false, onTap: () {})),
            SizedBox(
                width: _singleElementWidth * 7.6,
                height: _singleElementWidth,
                child: KeyboardElement('space', true, onTap: onTapEle(' '))),
            SizedBox(
                width: _singleElementWidth * 1.2,
                height: _singleElementWidth,
                child: KeyboardElement(' ', false, onTap: () {})),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (!paired)
              Expanded(child: NotSureButton(widget.correctAnswer, 0)),
            Expanded(child: NotSureButton(widget.correctAnswer, -1)),
            if (paired)
              Expanded(
                  child: SureButton(onTap: (_) {
                if (finished == false) {
                  setState(() {
                    finished = true;
                  });
                } else {
                  context.read<LakeModel>().learnSpellWordGood(0,
                      simpleWord: widget.correctAnswer.simpleWord!);
                }
              }, widget.correctAnswer, 2, 4, text: '继续')),
          ],
        )
      ],
    );
  }

  int levenshtein(String s, String t) {
    if (s == t) {
      return 0;
    }
    if (s.isEmpty) {
      return t.length;
    }
    if (t.isEmpty) {
      return s.length;
    }

    List<int> v0 = List<int>.filled(t.length + 1, 0);
    List<int> v1 = List<int>.filled(t.length + 1, 0);

    for (int i = 0; i < t.length + 1; i < i++) {
      v0[i] = i;
    }

    for (int i = 0; i < s.length; i++) {
      v1[0] = i + 1;

      for (int j = 0; j < t.length; j++) {
        int cost = (s[i] == t[j]) ? 0 : 1;
        v1[j + 1] = min(v1[j] + 1, min(v0[j + 1] + 1, v0[j] + cost));
      }

      for (int j = 0; j < t.length + 1; j++) {
        v0[j] = v1[j];
      }
    }

    return v1[t.length];
  }
}

class KeyboardElement extends StatelessWidget {
  const KeyboardElement(this.ind, this.shine,
      {required this.onTap, Key? key, this.onLongTap})
      : super(key: key);

  final String ind;
  final bool shine;
  final Function() onTap;
  final Function()? onLongTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongTap ?? () {},
      child: Container(
        decoration: BoxDecoration(
            color: shine ? Colors.black54 : Colors.black12,
            borderRadius: BorderRadius.all(Radius.circular(5.r))),
        margin: EdgeInsets.only(right: 4.w, bottom: 6.w),
        child: Center(
            child: Text(ind,
                style: shine ? TextUtil.base.white : TextUtil.base.opaGrey)),
      ),
    );
  }
}
