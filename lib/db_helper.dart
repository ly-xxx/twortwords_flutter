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
      _dbMyself =
          sqlite3.open(p.join(applicationDirectory.path, 'myself.db'));
      _dbMyself.execute('''
        CREATE TABLE IF NOT EXISTS learn (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              word VARCHAR(64) NOT NULL UNIQUE,
              sw VARCHAR(64),
              status VARCHAR(16),
              note TEXT
          );
        ''');
      // }
    }
    // }
  }

  addWordsFromFilter(String filter) async {
    io.Directory applicationDirectory =
    await getApplicationDocumentsDirectory();
    _dbMyself =
        sqlite3.open(p.join(applicationDirectory.path, 'myself.db'));
    final ResultSet resultSet =
    _dbUsing.select('SELECT * FROM stardict WHERE tag LIKE \'%$filter%\'');

    // You can iterate on the result set in multiple ways to retrieve Row objects
    // one by one.
    for (final Row row in resultSet) {
      _dbMyself.execute(
          'INSERT INTO learn VALUES (${row['id']}, \'${row['word']}\', \'${row['sw']}\', \'0\', \'\')');
    }
  }

  List<EnglishWord> searchAll(String tar, int offset) {
    List<EnglishWord> defList = [];
    final ResultSet resultSet = _dbUsing.select(
        'SELECT * FROM stardict WHERE sw LIKE \'$tar%\' LIMIT 50 OFFSET $offset');

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

  String randomWord() {
    return _dbMyself.select(
        'SELECT * FROM learn ORDER BY random() LIMIT 1').first['word'];
  }
}
