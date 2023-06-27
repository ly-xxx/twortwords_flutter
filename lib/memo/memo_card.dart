import 'dart:ui';

import 'package:bobwords/memo/learn_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'lake_notifier.dart';

class MemoCard extends StatefulWidget {
  const MemoCard({Key? key}) : super(key: key);

  @override
  State<MemoCard> createState() => _MemoCardState();
}

class _MemoCardState extends State<MemoCard> {
  @override
  void initState() {
    super.initState();
    context.read<LakeModel>().initArea();
  }

  int sectionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
              child: Container(
                height: 1.sh - MediaQuery.of(context).padding.top - 20.h,
                width: 1.sw,
                decoration: const BoxDecoration(
                  color: Colors.black87,
                ),
                child: Selector<LakeModel, int>(
                    selector: (context, model) =>
                        model.cardAreas[sectionIndex]!.widgetList.length,
                    //如果前后两次的count不相等，则刷新
                    shouldRebuild: (preCount, nextCount) => preCount != nextCount,
                    builder: (context, count, child) {
                      return ListView(
                          padding: EdgeInsets.only(top: 10.w),
                          controller: context
                              .read<LakeModel>()
                              .cardAreas[sectionIndex]
                              ?.controller,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            ...context
                                .read<LakeModel>()
                                .cardAreas[sectionIndex]!
                                .widgetList,
                            Padding(
                              padding: EdgeInsets.only(bottom: 100.h - 20.w),
                              child: const SpaceCard(),
                            )
                          ]);
                    }),
              ),
            )),
      ],
    );
  }
}
