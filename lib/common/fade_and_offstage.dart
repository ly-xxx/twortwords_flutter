import 'package:flutter/material.dart';

class FadeAndOffstage extends StatefulWidget {

  const FadeAndOffstage({required this.show, required this.child, this.durMilSec, Key? key})
      : super(key: key);

  final bool show;

  final int? durMilSec;

  final Widget child;

  @override
  State<FadeAndOffstage> createState() => _FadeAndOffstageState();
}

class _FadeAndOffstageState extends State<FadeAndOffstage> {
  bool transiting = true;
  late bool show;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    show = widget.show;
    if (show) transiting = true;
    return Offstage(
      offstage: !transiting,
      child: AnimatedOpacity(
          opacity: show && transiting ? 1 : 0,
          duration: Duration(milliseconds: widget.durMilSec ?? 300),
          curve: Curves.easeInOutCubic,
          onEnd: () => setState(() {
            show ? {} : transiting = false;
          }),
          child: widget.child),
    );
  }
}
