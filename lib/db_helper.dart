import 'package:flutter/services.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

import 'common/common_prefs.dart';
import 'common/model/english_word.dart';

class DictionaryDataBaseHelper {
  static late Database _dbUsing;
  static late Database _dbMyself;

  Future<void> initWordDB() async {
    await CommonPreferences.init();

    io.Directory applicationDirectory =
        await getApplicationDocumentsDirectory();

    if (!await applicationDirectory.exists()) {
      await applicationDirectory.create(recursive: true);
    }
    // Copy from asset
    if (!await io.File(p.join(applicationDirectory.path, 'stardict.db'))
        .exists()) {
      ByteData data =
          await rootBundle.load(p.join("assets/db/", "stardict.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await io.File(p.join(applicationDirectory.path, 'stardict.db'))
          .writeAsBytes(bytes, flush: true);
    }
    _dbUsing = sqlite3.open(p.join(applicationDirectory.path, 'stardict.db'));
    print('init success');
  }

  Future<void> initMyselfDB({io.File? myDB}) async {
    io.Directory applicationDirectory =
        await getApplicationDocumentsDirectory();
    if (myDB == null) {
      if (!await applicationDirectory.exists()) {
        await applicationDirectory.create(recursive: true);
      }
      // Copy from asset
      // if (!await io.File(p.join(applicationDirectory.path, 'myself.db'))
      //     .exists()) {
      await io.File(p.join(applicationDirectory.path, 'myself.db')).create();
      _dbMyself = sqlite3.open(p.join(applicationDirectory.path, 'myself.db'));
      _dbMyself.execute('''
        CREATE TABLE IF NOT EXISTS learn (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              word VARCHAR(64) NOT NULL UNIQUE,
              times VARCHAR(16),
              learn VARCHAR(16),
              learning VARCHAR(16),
              note TEXT
          );
        ''');
      final ResultSet resultSet =
          _dbUsing.select('SELECT * FROM stardict WHERE tag LIKE \'%ky%\'');
      print(resultSet);
      for (final Row row in resultSet) {
        _dbMyself.execute(
            'INSERT INTO learn (word, times, learn, learning, note) VALUES (\'${row['word']}\', \'0\', \'0\', \'0\', \'\')');
        print(row['word']);
      }
      // }
    }
    // }
  }

  addWordsFromFilter(String filter) async {
    io.Directory applicationDirectory =
        await getApplicationDocumentsDirectory();
    _dbMyself = sqlite3.open(p.join(applicationDirectory.path, 'myself.db'));
    final ResultSet resultSet =
        _dbUsing.select('SELECT * FROM stardict WHERE tag LIKE \'%$filter%\'');
    print(resultSet);
    for (final Row row in resultSet) {
      _dbMyself.execute(
          'INSERT INTO learn (word, times, learn, note) VALUES (\'${row['word']}\', \'0\', \'0\', \'\')');
      print(row['word']);
    }
  }

  List<EnglishWord> searchAll(String tar, int offset, {int? pageSize}) {
    List<EnglishWord> defList = [];
    final ResultSet resultSet = _dbUsing.select(
        'SELECT * FROM stardict WHERE sw LIKE \'$tar%\' LIMIT ${pageSize ?? 50} OFFSET $offset');

    for (final Row defRow in resultSet) {
      EnglishWord def = EnglishWord.fromRow(defRow);
      if (def.translation.isNotEmpty) {
        defList.add(def);
      }
    }
    return defList;
  }

  List<EnglishWord> searchMyself(String tar, int offset) {
    List<EnglishWord> defList = [];
    final ResultSet resultSet = _dbMyself.select(
        'SELECT * FROM learn WHERE word LIKE \'$tar%\' LIMIT 50 OFFSET $offset');

    for (final Row defRow in resultSet) {
      EnglishWord def = EnglishWord.fromRow(defRow);
      if (def.translation.isNotEmpty) {
        defList.add(def);
      }
    }
    return defList;
  }

  EnglishWord searchSingleWordFromAll(String tar, SimpleWord sw) {
    final ResultSet resultSet = _dbUsing
        .select('SELECT * FROM stardict WHERE word LIKE \'$tar\' LIMIT 1');

    EnglishWord def = EnglishWord.fromRow(resultSet.first);
    def.simpleWord = sw;
    return def;
  }

  //////////
  EnglishWord learnANewWord({bool? forceNew}) {
    SimpleWord wd;
    wd = getAWordOfMinIdWithTimesAndLearn('0', '0', '1');
    print(
        'id: ${wd.id}, times: ${wd.times}, learn: ${wd.learn}, learning: ${wd.learning}');
    if ((forceNew ?? false) || wd.id == -1) {
      print("searching");
      while (true) {
        wd = randomWord();
        if (wd.times == '0') break;
      }
      wd.times = '1';
      wd.learn = '0';
      wd.learning = '1';
      updateLearningWords(wd);
    }
    wd.times = '1';
    return searchSingleWordFromAll(wd.word, wd);
  }

  learnWordBad(SimpleWord wd) {
    wd.times = '0';
    wd.learn = '0';
    wd.learning = '1';
    updateLearningWords(wd);
  }

  learnNewWordGood(SimpleWord wd) {
    wd.times = '1';
    wd.learn = '1';
    updateLearningWords(wd);
  }

  //////////
  EnglishWord learnABlindWord({SimpleWord? wd}) {
    wd ??= getAWordOfMinIdWithTimesAndLearn('1', '1', '1');
    return searchSingleWordFromAll(wd.word, wd);
  }

  learnBlindWordGood(SimpleWord wd) {
    wd.times = '1';
    wd.learn = '2';
    updateLearningWords(wd);
  }

  //////////
  EnglishWord learnASpellWord({SimpleWord? wd}) {
    wd ??= getAWordOfMinIdWithTimesAndLearn('1', '2', '1');
    return searchSingleWordFromAll(wd.word, wd);
  }

  learnSpellWordGood(SimpleWord wd) {
    wd.times = '1';
    wd.learn = '3';
    updateLearningWords(wd);
  }

  //////////
  EnglishWord learnABlindSpellWord({SimpleWord? wd}) {
    wd ??= getAWordOfMinIdWithTimesAndLearn('1', '3', '1');
    return searchSingleWordFromAll(wd.word, wd);
  }

  learnBlindSpellWordGood(SimpleWord wd) {
    wd.times = '2';
    wd.learn = '0';
    wd.learning = '0';
    updateLearningWords(wd);
  }

  //////////

  updateLearningWords(SimpleWord sw) {
    _dbMyself.select(
        '''UPDATE learn SET word = \'${sw.word}\', times = \'${sw.times}\', 
        learn = \'${sw.learn}\', learning = \'${sw.learning}\', note = \'${sw.note}\' WHERE id = \'${sw.id}\'''');
  }

  SimpleWord randomWord() {
    final ResultSet resultSet =
        _dbMyself.select('SELECT * FROM learn ORDER BY random() LIMIT 1');
    return SimpleWord.fromRow(resultSet.first);
  }

  SimpleWord getAWordOfMinIdWithTimesAndLearn(
      String times, String learn, String learning) {
    final ResultSet resultSet = _dbMyself.select(
        'SELECT * FROM learn WHERE times = \'$times\' AND learn = \'$learn\' AND learning = \'$learning\' ORDER BY id DESC LIMIT 1');
    if (resultSet.isEmpty) {
      return SimpleWord(
          id: -1, word: '', times: '', learn: '', note: '', learning: '');
    } else {
      return SimpleWord.fromRow(resultSet.first);
    }
  }

  List<SimpleWord> getLimitedLastWordsLearningFilteredWith(
      {required String limit, required String times, required String learn}) {
    List<SimpleWord> sl = [];
    final ResultSet resultSet = _dbMyself.select(
        'SELECT * FROM learn WHERE times = \'$times\' AND learn = \'$learn\' AND learning = \'1\' ORDER BY id DESC LIMIT $limit');
    for (final Row defRow in resultSet) {
      SimpleWord def = SimpleWord.fromRow(defRow);
      sl.add(def);
    }
    if (sl.length == 4) {
      return sl;
    } else {
      return [];
    }
  }
}
