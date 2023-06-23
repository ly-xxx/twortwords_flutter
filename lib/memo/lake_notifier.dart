import 'package:bobwords/common/model/english_word.dart';
import 'package:bobwords/db_helper.dart';
import 'package:flutter/material.dart';

enum LakePageStatus {
  unload,
  loading,
  idle,
  error,
}

class LakeArea {
  final Map<int, EnglishWord> dataList;
  final ScrollController controller;
  late LakePageStatus status;
  int currentCard = 0;

  LakeArea._(this.dataList, this.controller, LakePageStatus unload);

  factory LakeArea.empty() {
    return LakeArea._({}, ScrollController(), LakePageStatus.unload);
  }
}

class LakeModel extends ChangeNotifier {
  Map<int, LakeArea> cardAreas = {};
  bool openFeedbackList = false, tabControllerLoaded = false, scroll = false;
  bool barExtended = true;
  double opacity = 0;
  int sortSeq = 1;

  clearAll() {
    cardAreas.clear();
    openFeedbackList = false;
    tabControllerLoaded = false;
    scroll = false;
    barExtended = true;
    opacity = 0;
    sortSeq = 1;
  }

  void onFeedbackOpen() {
    barExtended = true;
    notifyListeners();
  }

  void onFeedbackClose() {
    barExtended = false;
    notifyListeners();
  }

  void initLakeArea(int index, ScrollController sController) {
    LakeArea lakeArea =
        LakeArea._({}, ScrollController(), LakePageStatus.unload);
  }

  Future<void> initArea() async {
    cardAreas.addAll({0: LakeArea.empty()});
    initLakeArea(0, ScrollController());
    await initCardList(0);
    notifyListeners();
  }

  // void fillLakeAreaAndInitPostList(
  //     int index, ScrollController sController) {
  //   LakeArea lakeArea = new LakeArea._(lakeAreas[index].tab, {}, rController,
  //       sController, LakePageStatus.unload);
  //   lakeAreas[index] = lakeArea;
  //   initPostList(index, success: () {}, failure: (e) {
  //     ToastProvider.error(e.error.toString());
  //   });
  // }

  // 列表去重
  void _addOrUpdateItems(List<EnglishWord> data, int index) {
    for (var element in data) {
      cardAreas[index]
          ?.dataList
          .update(element.id, (value) => element, ifAbsent: () => element);
    }
  }

  Future<void> getNextCard(int index) async {
    // print('happybird1');
    List<EnglishWord> cardList = [];
    // print('happybird2');
    cardList.add(DictionaryDataBaseHelper().learnANewWord());
    // print('happybird3');
    _addOrUpdateItems(cardList, index);
    // print('happybird4');
    cardAreas[index]!.currentCard += 1;
    // print('happybird5');
    notifyListeners();
  }

  Future<void> initCardList(int index) async {
    tabControllerLoaded = true;
    if (cardAreas[index]?.dataList != null) {
      cardAreas[index]?.dataList.clear();
    }
    List<EnglishWord> cardList = [];
    DictionaryDataBaseHelper()
        .initWordDB()
        .whenComplete(() => DictionaryDataBaseHelper().initMyselfDB().whenComplete(() {
              cardList.add(DictionaryDataBaseHelper().learnANewWord());
              cardList.add(DictionaryDataBaseHelper().learnANewWord());
              _addOrUpdateItems(cardList, index);
              cardAreas[index]!.currentCard = 2;
            }));
  }
}
