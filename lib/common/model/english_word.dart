import 'dart:convert';
import 'package:sqlite3/sqlite3.dart';

/// word	单词名称
/// phonetic	音标，以英语英标为主
/// definition	单词释义（英文），每行一个释义
/// translation	单词释义（中文），每行一个释义
/// pos	词语位置，用 "/" 分割不同位置
/// collins	柯林斯星级
/// oxford	是否是牛津三千核心词汇
/// tag	字符串标签：zk/中考，gk/高考，cet4/四级 等等标签，空格分割
/// bnc	英国国家语料库词频顺序
/// frq	当代语料库词频顺序
/// exchange	时态复数等变换，使用 "/" 分割不同项目，见后面表格
/// detail	json 扩展信息，字典形式保存例句（待添加）
/// audio	读音音频 url （待添加）

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
    required this.collins,
    required this.oxford,
    required this.bncSeq,
    required this.frqSeq,
    required this.exchange,
  });

  int id;
  String word;
  String sw;
  String phonetic;
  String definition;
  String translation;
  String pos;
  String tag;
  String collins;
  String oxford;
  String bncSeq;
  String frqSeq;
  String exchange;

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
      collins: json["collins"],
      oxford: json["oxford"],
      bncSeq: json["bnc"],
      frqSeq: json["frq"],
      exchange: json["exchange"]);

  factory EnglishWord.fromRow(Row row) => EnglishWord(
      id: row['id'],
      word: row['word'].toString(),
      sw: row['sw'].toString(),
      phonetic: row['phonetic'].toString(),
      definition: row['definition'].toString(),
      translation: row['translation'].toString(),
      pos: row['pos'].toString(),
      tag: row['tag'].toString(),
      collins: row['collins'].toString(),
      oxford: row['oxford'].toString(),
      bncSeq: row['bnc'].toString(),
      frqSeq: row['frq'].toString(),
      exchange: row['exchange'].toString());

  Map<String, dynamic> toJson() => {
        "id": id,
        "word": word,
        "sw": sw,
        "phonetic": phonetic,
        "definition": definition,
        "translation": translation,
        "pos": pos,
        "tag": tag,
        "collins": collins,
        "oxford": oxford,
        "bnc": bncSeq,
        "frq": frqSeq,
        "exchange": exchange,
      };
}

class SimpleWord {
  SimpleWord({
    required this.id,
    required this.word,
    required this.times,
    required this.learn,
    required this.note,
  });

  int id;
  String word;
  String times;
  String learn;
  String note;

  factory SimpleWord.fromRawJson(String str) =>
      SimpleWord.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SimpleWord.fromJson(Map<String, dynamic> json) => SimpleWord(
      id: json["id"],
      word: json["word"],
      times: json["times"],
      learn: json["learn"],
      note: json["note"],
  );

  factory SimpleWord.fromRow(Row row) => SimpleWord(
      id: row['id'],
      word: row['word'].toString(),
      times: row['times'].toString(),
      learn: row['learn'].toString(),
      note: row['note'].toString(),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "word": word,
    "times": times,
    "learn": learn,
    "note": note,
  };
}