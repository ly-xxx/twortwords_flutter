import 'package:bobwords/common/model/english_word.dart';
import 'package:bobwords/common/word_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SimpleItem extends StatefulWidget {
  EnglishWord englishWord;

  SimpleItem(this.englishWord, {Key? key}) : super(key: key);

  @override
  State<SimpleItem> createState() => _SimpleItemState();
}

class _SimpleItemState extends State<SimpleItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => WordDetails(widget.englishWord))),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 7.w),
        child: Row(children: [
          SizedBox(
              height: 20,
              width: 0.35.sw,
              child: Text(widget.englishWord.word,
                  overflow: TextOverflow.ellipsis)),
          SizedBox(width: 7.w),
          Expanded(
            child: SizedBox(
                height: 20,
                child: Text(widget.englishWord.translation,
                    overflow: TextOverflow.ellipsis)),
          ),
        ]),
      ),
    );
  }
}
