import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextUtil {
  TextUtil._();

  static TextStyle base = const TextStyle();

  static init(BuildContext context) {
    base = Theme.of(context).textTheme.bodyMedium ?? const TextStyle();
    base = base.Swis;
  }
}

extension TextStyleAttr on TextStyle {
  /// 粗细
  TextStyle get w100 =>
      copyWith(fontWeight: FontWeight.w100); // Thin, the least thick
  TextStyle get w200 =>
      copyWith(fontWeight: FontWeight.w200); // Extra-light
  TextStyle get w300 => copyWith(fontWeight: FontWeight.w300); // Light
  TextStyle get w400 =>
      copyWith(fontWeight: FontWeight.w400); // Normal / regular / plain
  TextStyle get w500 => copyWith(fontWeight: FontWeight.w500); // Medium
  TextStyle get w600 => copyWith(fontWeight: FontWeight.w600); // Semi-bold
  TextStyle get w700 => copyWith(fontWeight: FontWeight.w700); // Bold
  TextStyle get w800 =>
      copyWith(fontWeight: FontWeight.w800); // Extra-bold
  TextStyle get w900 =>
      copyWith(fontWeight: FontWeight.w900); // Black, the most thick
  TextStyle get regular => w400;

  TextStyle get normal => w400;

  TextStyle get medium => w500;

  TextStyle get bold => w700;

  /// 颜色
  TextStyle customColor(Color c) => copyWith(color: c);

  TextStyle get white => copyWith(color: Colors.white);

  TextStyle get whiteFD => copyWith(color: const Color(0xFFFDFDFE));

  TextStyle get mainOrange => copyWith(color: const Color(0xFFFF6F48));

  TextStyle get dangerousRed => copyWith(color: const Color(0xFFFF0000));

  TextStyle get textButtonBlue => copyWith(color: const Color(0xFF2D4E9A));

  TextStyle get begoniaPink => copyWith(color: const Color(0xFFF3C9D9));

  TextStyle get biliPink => copyWith(color: const Color(0xFFF97198));

  TextStyle get linkBlue => copyWith(color: const Color(0xFF222F80));

  TextStyle get mainYellow => copyWith(color: const Color(0xFFFABC35));

  TextStyle get mainGrey => copyWith(color: const Color(0xFFB6B2AF));

  TextStyle get mainPurple => copyWith(color: const Color(0xFF6A63E1));

  TextStyle get greyEB => copyWith(color: const Color(0xFFEBEBEB));

  TextStyle get greyAA => copyWith(color: const Color(0xFFAAAAAA));

  TextStyle get greyA8 => copyWith(color: const Color(0xFFA8A8A8));

  TextStyle get greyA6 => copyWith(color: const Color(0xFFA6A6A6));

  TextStyle get greyB2 => copyWith(color: const Color(0xFFB2B6BB));

  TextStyle get grey97 => copyWith(color: const Color(0xFF979797));

  TextStyle get opaGrey => copyWith(color: const Color(0x886C6C6C));

  TextStyle get greyC8 => copyWith(color: const Color(0xFFC8C8C8));

  TextStyle get blue303C => copyWith(color: const Color(0xFF303C66));

  TextStyle get blue363C => copyWith(color: const Color(0xFF363C54));

  TextStyle get black00 => copyWith(color: const Color(0xFF000000));

  TextStyle get deeperGrey => copyWith(color: const Color(0xFF4E4E4E));

  TextStyle get grey126 =>
      copyWith(color: const Color.fromARGB(255, 126, 126, 126));

  TextStyle get black2A => copyWith(color: const Color(0xFF2A2A2A));

  TextStyle get greenCorrect => copyWith(color: const Color(0xFF1D624B));

  TextStyle get green5C => copyWith(color: const Color(0xFF5CB85C));

  TextStyle get yellowD9 => copyWith(color: const Color(0xFFD9621F));

  TextStyle get redD9 => copyWith(color: const Color(0xFFD9534F));

  TextStyle get orange6B => copyWith(color: const Color(0xFFFFBC6B));

  TextStyle get mainColor =>
      copyWith(color: const Color.fromARGB(255, 54, 60, 84));

  TextStyle get blue2C => copyWith(color: const Color(0xFF2C7EDF));

  TextStyle get transParent => copyWith(color: const Color(0x00000000));

  /// 字体
  TextStyle get Swis => copyWith(fontFamily: 'Swis');

  TextStyle get NotoSansSC => copyWith(fontFamily: 'NotoSansSC');

  TextStyle get PingFangSC => copyWith(fontFamily: 'PingFangSC');

  TextStyle get ProductSans => copyWith(fontFamily: 'ProductSans');

  TextStyle get Fourche => copyWith(fontFamily: 'Fourche');

  /// 装饰
  TextStyle get lineThrough =>
      copyWith(decoration: TextDecoration.lineThrough);

  TextStyle get overLine => copyWith(decoration: TextDecoration.overline);

  TextStyle get underLine =>
      copyWith(decoration: TextDecoration.underline);

  TextStyle get noLine => copyWith(decoration: TextDecoration.none);

  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);

  /// 以下为非枚举属性
  TextStyle sp(double s) => copyWith(fontSize: s.sp);

  TextStyle h(double h) => copyWith(height: h);

  TextStyle space({double? wordSpacing, double? letterSpacing}) =>
      copyWith(wordSpacing: wordSpacing, letterSpacing: letterSpacing);
}
