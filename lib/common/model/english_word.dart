import 'dart:convert';
import 'package:sqlite3/sqlite3.dart';

class EnglishWord {
  EnglishWord({
    required this.id,
    required this.word,
    required this.sw,
    required this.phonetic,
    required this.definition,
    required this.translation,
    required this.pos,
    required this.tag,
  });

  int id;
  String word;
  String sw;
  String phonetic;
  String definition;
  String translation;
  String pos;
  String tag;

  factory EnglishWord.fromRawJson(String str) =>
      EnglishWord.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EnglishWord.fromJson(Map<String, dynamic> json) => EnglishWord(
        id: json["id"],
        word: json["word"],
        sw: json["sw"],
        phonetic: json["phonetic"],
        definition: json["definition"],
        translation: json["translation"],
        pos: json["pos"],
        tag: json["tag"],
      );

  factory EnglishWord.fromRow(Row row) => EnglishWord(
      id: row['id'],
      word: row['word'].toString(),
      sw: row['sw'].toString(),
      phonetic: row['phonetic'].toString(),
      definition: row['definition'].toString(),
      translation: row['translation'].toString(),
      pos: row['pos'].toString(),
      tag: row['tag'].toString());

  Map<String, dynamic> toJson() => {
        "id": id,
        "word": word,
        "sw": sw,
        "phonetic": phonetic,
        "definition": definition,
        "translation": translation,
        "pos": pos,
        "tag": tag,
      };
}
