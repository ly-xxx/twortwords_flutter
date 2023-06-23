import 'dart:async';

import 'package:bobwords/common/background_container.dart';
import 'package:bobwords/common/basic_widgets/word_widgets.dart';
import 'package:bobwords/common/fade_and_offstage.dart';
import 'package:bobwords/db_helper.dart';
import 'package:bobwords/search/search_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';

import 'common/common_prefs.dart';
import 'common/text_util.dart';
import 'common/time_util.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await CommonPreferences.init();

    runApp(const MyApp());
  }, (Object error, StackTrace stack) {});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '小而美词典'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  static final GlobalKey<NavigatorState> navigatorState = GlobalKey();

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// 0 查词 1 主页 2 复习
  int status = 1;

  late bool switchable;

  late double searPosition, mainPosition, memoPosition;

  double panDownY = 0;

  ScrollController scrollController = ScrollController();

  FocusNode fn = FocusNode();

  @override
  void initState() {
    // CommonPreferences.lastDaySigned.value = 0;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var baseContext =
          MyHomePage.navigatorState.currentState?.overlay?.context;

      TextUtil.init(baseContext!);
    });

    DictionaryDataBaseHelper()
        .initWordDB()
        .then((_) => DictionaryDataBaseHelper().initMyselfDB());
    Future.delayed(const Duration(milliseconds: 800)).then((_) {
      searPosition = 0;
      mainPosition = 0.2.sh;
      memoPosition = 0.4.sh;
      switchable = true;
      scrollController.animateTo(mainPosition,
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeInOutCubicEmphasized);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return WillPopScope(
            onWillPop: () async {
              if (status != 1) {
                scrollController.animateTo(mainPosition,
                    duration:
                    const Duration(milliseconds: 200),
                    curve: Curves.easeInOutCubicEmphasized);
                status = 1;
                switchable = false;
                if (FocusScope.of(context).hasFocus) {
                  fn.unfocus();
                }
                return false;
              } else {
                return true;
              }
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.grey,
              body: Stack(
                children: [
                  SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: scrollController,
                    child: BackgroundContainer(
                      child: Stack(
                        children: [
                          GestureDetector(
                              onPanDown: (DragDownDetails e) {
                                panDownY = e.globalPosition.dy;
                              },
                              onPanUpdate: (DragUpdateDetails e) {
                                double rel = e.globalPosition.dy - panDownY;
                                if (rel.abs() > 20) {
                                  bool direction = rel.isNegative;
                                  // 往上滑，往下移
                                  if (direction && status == 0 && switchable) {
                                    scrollController.animateTo(mainPosition,
                                        duration:
                                            const Duration(milliseconds: 200),
                                        curve: Curves.easeInOutCubicEmphasized);
                                    status = 1;
                                    switchable = false;
                                    if (FocusScope.of(context).hasFocus) {
                                      fn.unfocus();
                                    }
                                  }
                                  if (!direction && status == 1 && switchable) {
                                    scrollController.animateTo(searPosition,
                                        duration:
                                            const Duration(milliseconds: 200),
                                        curve: Curves.easeInOutCubicEmphasized);
                                    status = 0;
                                    switchable = false;
                                    FocusScope.of(context).requestFocus(fn);
                                  }
                                  if (direction && status == 1 && switchable) {
                                    scrollController.animateTo(memoPosition,
                                        duration:
                                            const Duration(milliseconds: 200),
                                        curve: Curves.easeInOutCubicEmphasized);
                                    status = 2;
                                    switchable = false;
                                    setState(() {});
                                  }
                                  if (!direction && status == 2 && switchable) {
                                    scrollController.animateTo(mainPosition,
                                        duration:
                                            const Duration(milliseconds: 200),
                                        curve: Curves.easeInOutCubicEmphasized);
                                    status = 1;
                                    switchable = false;
                                    setState(() {});
                                  }
                                }
                              },
                              onPanEnd: (_) => switchable = true,
                              child: Container(color: Colors.transparent)),
                          FadeAndOffstage(
                            show: status == 0,
                            child: SafeArea(
                              child: SearchCard(fn),
                            ),
                          ),
                          FadeAndOffstage(
                              durMilSec: 600,
                              show: status == 1,
                              child: Align(
                                alignment: const Alignment(0, -0.1),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    FadeAndOffstage(
                                        show: daysSince1970InBJTime ==
                                            CommonPreferences
                                                .lastDaySigned.value,
                                        child: BasicBigWord(
                                          CommonPreferences
                                                      .recommendedWord.value ==
                                                  ''
                                              ? 'Welcome!'
                                              : CommonPreferences
                                                  .recommendedWord.value,
                                        )),
                                    FadeAndOffstage(
                                      durMilSec: 3000,
                                      show: daysSince1970InBJTime !=
                                          CommonPreferences.lastDaySigned.value,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  CommonPreferences
                                                          .lastDaySigned.value =
                                                      daysSince1970InBJTime;
                                                  CommonPreferences
                                                      .points.value += 10;
                                                  CommonPreferences
                                                          .recommendedWord
                                                          .value =
                                                      DictionaryDataBaseHelper()
                                                          .randomWord();
                                                });
                                              },
                                              child: BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                      sigmaX: 2.0, sigmaY: 2.0),
                                                  child: AnimatedContainer(
                                                    height: 100.h,
                                                    width: 100.h,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.r),
                                                        color: daysSince1970InBJTime !=
                                                                CommonPreferences
                                                                    .lastDaySigned
                                                                    .value
                                                            ? Colors
                                                                .grey.shade200
                                                                .withOpacity(
                                                                    0.6)
                                                            : Colors.white70),
                                                    duration: const Duration(
                                                        milliseconds: 400),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        daysSince1970InBJTime !=
                                                                CommonPreferences
                                                                    .lastDaySigned
                                                                    .value
                                                            ? SvgPicture.asset(
                                                                'assets/svg/sign_in_logo.svg',
                                                                height: 40.h,
                                                                fit: BoxFit
                                                                    .fitHeight)
                                                            : Text('积分 +10',
                                                                style: TextUtil
                                                                    .base
                                                                    .w700
                                                                    .opaGrey
                                                                    .sp(18)),
                                                        Text(
                                                            daysSince1970InBJTime !=
                                                                    CommonPreferences
                                                                        .lastDaySigned
                                                                        .value
                                                                ? '签到'
                                                                : '完成',
                                                            style: TextUtil.base
                                                                .w700.black2A
                                                                .sp(20))
                                                      ],
                                                    ), //17abe3
                                                  )),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
