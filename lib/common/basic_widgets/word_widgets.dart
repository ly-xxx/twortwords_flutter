import 'dart:ffi';
import 'dart:ui';

import 'package:bobwords/common/fade_and_offstage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../text_util.dart';

class BasicBigWord extends StatefulWidget {
  BasicBigWord(this.word,
      {this.withPieChart, this.pieChartSrc, this.leftAlign, this.width, Key? key})
      : super(key: key);
  String word;
  late bool? withPieChart;
  late String? pieChartSrc;
  late double? width;
  late bool? leftAlign;

  @override
  State<BasicBigWord> createState() => _BasicBigWordState();
}

class _BasicBigWordState extends State<BasicBigWord> {
  double radius = 12.h;

  bool flipPieChart = true;

  List<PieChartSectionData> resolveSection(String pos) {
    List<PieChartSectionData> section = [];
    late List<String> s;
    s = pos.split('/');
    for (var e in s) {
      if (e.length > 2) {
        var title = e.substring(0, 1);
        var value = double.parse(e.substring(2));
        section.add(PieChartSectionData(
            title: title,
            showTitle: value >= 30,
            value: value,
            color: title == 'n'
                ? Colors.amber.shade300.withOpacity(0.6)
                : title == 'v'
                    ? Colors.amber.shade400.withOpacity(0.6)
                    : title == 'j'
                        ? Colors.amber.shade500.withOpacity(0.6)
                        : title == 'c'
                            ? Colors.amber.shade600.withOpacity(0.6)
                            : title == 'i'
                                ? Colors.amber.shade700.withOpacity(0.6)
                                : title == 'r'
                                    ? Colors.amber.shade800.withOpacity(0.6)
                                    : Colors.amber.shade900.withOpacity(0.6),
            titleStyle: TextUtil.base.white.w900.italic.sp(12),
            radius: radius));
      }
    }
    return section;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ConstrainedBox(
            constraints: ((widget.pieChartSrc ?? 'null') != 'null')
                ? BoxConstraints(maxWidth: (widget.width ??= 1.sw - 28.h) - 3 * radius)
                : BoxConstraints(maxWidth: widget.width ??= 1.sw - 28.h),
            child: Text(widget.word, style: TextUtil.base.white.w700.sp(40), maxLines: 3, overflow: TextOverflow.ellipsis)),
        if (((widget.pieChartSrc ?? 'null') != 'null') &&
            (widget.withPieChart ?? false))
          GestureDetector(
            onTap: () => setState(() => flipPieChart = !flipPieChart),
            child: Padding(
              padding: EdgeInsets.only(left: 6.h, top: 4.h),
              child: Stack(
                children: [
                  FadeAndOffstage(
                    show: flipPieChart,
                    child: SizedBox(
                      width: radius * 2,
                      height: radius * 2,
                      child: PieChart(
                        PieChartData(
                          sections: resolveSection(widget.pieChartSrc!),
                        ),
                        swapAnimationDuration:
                            const Duration(milliseconds: 150),
                        // Optional
                        swapAnimationCurve: Curves.linear, // Optional
                      ),
                    ),
                  ),
                  FadeAndOffstage(
                    show: !flipPieChart,
                    child: SizedBox(
                      width: radius * 3,
                      height: radius * 2,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(widget.pieChartSrc!.replaceAll('/', ' '),
                            style: TextUtil.base.white.w500.sp(9.95)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        widget.leftAlign ?? false ? const Spacer() : const SizedBox(),
      ],
    );
  }
}

class BasicPhonetic extends StatefulWidget {
  BasicPhonetic(this.phonetic, {this.word, this.read, Key? key}) : super(key: key);

  String phonetic;

  bool? read;

  late String? word;

  @override
  State<BasicPhonetic> createState() => _BasicPhoneticState();
}

class _BasicPhoneticState extends State<BasicPhonetic> {
  late FlutterTts flutterTts;

  @override
  void initState() {
    flutterTts = FlutterTts();
    initTts();
    if ((widget.read ?? true) && widget.phonetic != 'null' && widget.phonetic != '') {
      read(widget.word!);
    }
    super.initState();
  }

  initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(1.0);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(0.3);
    await flutterTts.isLanguageAvailable("en-US");
  }

  read(String text) async {
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.word != null ? read(widget.word!) : {};
      },
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: Container(
                  padding: EdgeInsets.fromLTRB(6.h, 4.h, 6.h, 5.h),
                  height: 26.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: Colors.black26),
                  child: Text(
                      widget.phonetic == 'null' || widget.phonetic == ''
                          ? '尝试发音'
                          : '/${widget.phonetic}/',
                      style: TextUtil.base.white.w600
                          .sp(14)
                          .italic
                          .space(letterSpacing: 1))))),
    );
  }
}

class WordTag extends StatelessWidget {
  const WordTag(this.src, {Key? key}) : super(key: key);

  final String src;

  @override
  Widget build(BuildContext context) {
    String tar = src.replaceAll('zk', '中考').replaceAll('gk', '高考').replaceAll('ky', '考研').toUpperCase();
    return Padding(
      padding: EdgeInsets.only(left: 4.h),
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: Container(
                  padding: EdgeInsets.fromLTRB(6.h, 4.h, 6.h, 5.h),
                  height: 26.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: Colors.black26),
                  child: Center(
                    child: Text(tar,
                        style: TextUtil.base.white.w700
                            .sp(12)
                            .space(letterSpacing: 1)),
                  )))),
    );
  }
}
