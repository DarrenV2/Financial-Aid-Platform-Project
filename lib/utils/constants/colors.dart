import 'package:flutter/material.dart';

class TColors {
  TColors._();

  //app basic colors
  static const Color primary = Color.fromRGBO(54, 105, 254, 1);
  static const Color secondary = Color.fromRGBO(245, 245, 245, 1);
  static const Color accent = Color.fromRGBO(82, 82, 82, 1);

  //text colors
  static const Color textBlue = Color.fromRGBO(54, 105, 254, 1);
  static const Color textLightGray = Color.fromRGBO(108, 114, 127, 1);
  static const Color textGray = Color.fromRGBO(82, 82, 82, 1);

  //Background colors
  static const Color light = Color.fromRGBO(246, 246, 246, 1);
  static const Color dark = Color.fromRGBO(39, 39, 39, 1);
  static const Color primaryBackground = Color.fromRGBO(245, 245, 245, 1);

  //Background container colors
  static const Color lightContainer = Color(0xFFF6F6F6);
  static Color darkContainer = TColors.white.withOpacity(0.1);

  //Button colors
  static const Color buttonBlue = Color.fromRGBO(54, 105, 254, 1);
  static const Color buttonWhite = Color.fromARGB(255, 255, 255, 255);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  //Border colors
  static const Color borderPrimary = Color.fromRGBO(54, 105, 254, 1);
  static const Color borderSecondary = Color.fromRGBO(230, 230, 230, 1);

  //Error and validation colors
  static const Color error = Color.fromRGBO(211, 47, 47, 1);
  static const Color success = Color.fromRGBO(56, 142, 60, 1);
  static const Color warning = Color.fromRGBO(245, 124, 0, 1);
  static const Color info = Color.fromRGBO(54, 105, 254, 1);

  //Neutral shades
  static const Color black = Color.fromRGBO(35, 35, 35, 1);
  static const Color darkerGrey = Color.fromRGBO(79, 79, 79, 1);
  static const Color darkGrey = Color.fromRGBO(147, 147, 147, 1);
  static const Color grey = Color.fromRGBO(224, 224, 224, 1);
  static const Color softGrey = Color.fromRGBO(244, 244, 244, 1);
  static const Color lightGrey = Color.fromRGBO(249, 249, 249, 1);
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
}
