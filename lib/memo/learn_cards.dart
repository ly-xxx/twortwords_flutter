import 'package:bobwords/common/model/english_word.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      height: 0.4.sh,
      color: Colors.white,
      child: Text(widget.word.word),
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
