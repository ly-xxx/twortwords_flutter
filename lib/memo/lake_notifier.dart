import 'package:bobwords/common/model/english_word.dart';
import 'package:bobwords/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'learn_cards.dart';

enum LakePageStatus {
  unload,
  loading,
  idle,
  error,
}

class LakeArea {
  final List<Widget> widgetList;
  final ScrollController controller;
  late LakePageStatus status;
  int currentCard = 0;

  LakeArea._(this.widgetList, this.controller, LakePageStatus unload);

  factory LakeArea.empty() {
    return LakeArea._([], ScrollController(), LakePageStatus.unload);
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
        LakeArea._([], ScrollController(), LakePageStatus.unload);
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
  void _addItems(List<EnglishWord> data, int index) {
    for (var element in data) {
      switch (element.simpleWord?.learn) {
        case '0':
          cardAreas[index]?.widgetList.add(FirstLearnCard(element));
        case '1':
          cardAreas[index]?.widgetList.add(FirstLearnRw1Card(element));
        case '2':
          cardAreas[index]?.widgetList.add(FirstLearnSpell1Card(element));
        case '3':
          cardAreas[index]?.widgetList.add(FirstLearnSpell2Card(element));
        default:
          return cardAreas[index]?.widgetList.add(const SpaceCard());
      }
    }
  }

  Future<void> getNextCard(int index) async {
    // print('happybird1');
    List<EnglishWord> cardList = [];
    // print('happybird2');
    cardList.add(DictionaryDataBaseHelper().learnANewWord());
    // print('happybird3');
    _addItems(cardList, index);
    // print('happybird4');
    cardAreas[index]!.currentCard += 1;
    // print('happybird5');
    notifyListeners();
  }

  Future<void> initCardList(int index) async {
    tabControllerLoaded = true;
    if (cardAreas[index]?.widgetList != null) {
      cardAreas[index]?.widgetList.clear();
    }
    List<EnglishWord> cardList = [];
    DictionaryDataBaseHelper().initWordDB().whenComplete(() =>
        DictionaryDataBaseHelper().initMyselfDB().whenComplete(() {
          Future.delayed(const Duration(milliseconds: 400)).whenComplete(() {
            cardList.add(DictionaryDataBaseHelper().learnANewWord());
            Future.delayed(const Duration(milliseconds: 400)).whenComplete(() {
              _addItems(cardList, index);
              cardAreas[index]!.currentCard = 2;
              notifyListeners();
            });
          });
        }));
  }

  nextCard(int index) {
    cardAreas[index]!.currentCard += 1;
    cardAreas[index]?.controller.animateTo(
        cardAreas[index]!.controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCirc);
  }

  learnWordBad(int index, SimpleWord simpleWord) {
    DictionaryDataBaseHelper().learnWordBad(simpleWord);
    // cardAreas[index]!.dataList.remove(simpleWord.id);
    List<EnglishWord> cardList = [DictionaryDataBaseHelper().learnANewWord()];
    _addItems(cardList, index);
    nextCard(index);
    notifyListeners();
  }

  learnSpellWordBad(int index, SimpleWord simpleWord) {
    DictionaryDataBaseHelper().learnSpellWordBad(simpleWord);
    // cardAreas[index]!.dataList.remove(simpleWord.id);
    List<EnglishWord> cardList = [DictionaryDataBaseHelper().learnASpellWord()];
    _addItems(cardList, index);
    nextCard(index);
    notifyListeners();
  }

  learnNewWordGood(int index, {SimpleWord? simpleWord}) {
    List<SimpleWord> sl = DictionaryDataBaseHelper()
        .getLimitedLastWordsLearningFilteredWith(
            times: '1', learn: '1', limit: '4');
    if (simpleWord != null) {
      DictionaryDataBaseHelper().learnNewWordGood(simpleWord);
    }
    if (sl.isEmpty) {
      List<EnglishWord> cardList = [DictionaryDataBaseHelper().learnANewWord()];
      _addItems(cardList, index);
    } else {
      List<EnglishWord> cardList = [
        // 省一次查询
        DictionaryDataBaseHelper().learnABlindWord(wd: sl.first)
      ];
      _addItems(cardList, index);
    }
    nextCard(index);
    notifyListeners();
  }

  learnBlindWordGood(int index, {SimpleWord? simpleWord}) {
    List<SimpleWord> sl = DictionaryDataBaseHelper()
        .getLimitedLastWordsLearningFilteredWith(
            times: '1', learn: '2', limit: '4');
    if (simpleWord != null) {
      DictionaryDataBaseHelper().learnBlindWordGood(simpleWord);
    }
    if (sl.isEmpty) {
      learnNewWordGood(index);
    } else {
      List<EnglishWord> cardList = [
        DictionaryDataBaseHelper().learnASpellWord(wd: sl.first)
      ];
      _addItems(cardList, index);
    }
    nextCard(index);
    notifyListeners();
  }

  learnSpellWordGood(int index, {SimpleWord? simpleWord}) {
    List<SimpleWord> sl = DictionaryDataBaseHelper()
        .getLimitedLastWordsLearningFilteredWith(
            times: '1', learn: '3', limit: '4');
    if (simpleWord != null) {
      DictionaryDataBaseHelper().learnSpellWordGood(simpleWord);
    }
    if (sl.isEmpty) {
      learnBlindWordGood(index);
    } else {
      List<EnglishWord> cardList = [
        DictionaryDataBaseHelper().learnABlindSpellWord(wd: sl.first)
      ];
      _addItems(cardList, index);
    }
    nextCard(index);
    notifyListeners();
  }

  learnBlindSpellWordGood(int index, {SimpleWord? simpleWord}) {
    if (simpleWord != null) {
      DictionaryDataBaseHelper().learnBlindSpellWordGood(simpleWord);
    }
    List<EnglishWord> cardList = [DictionaryDataBaseHelper().learnANewWord()];
    _addItems(cardList, index);
    nextCard(index);
    notifyListeners();
  }
}
