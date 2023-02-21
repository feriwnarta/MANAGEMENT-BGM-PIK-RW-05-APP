import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    textTheme: lightTextTheme,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: Color(0xff2196F3),
    ),
    primaryColor: primary,
    fontFamily: 'Inter',
  );

  static TextTheme lightTextTheme = TextTheme(
    headline1: headline1Light,
    headline2: headline2Light,
    headline3: headline3Light,
    subtitle1: subtitle1Light,
    subtitle2: subtitle2Light,
    bodyText1: body1Light,
    bodyText2: body2Light,
    button: buttonLight,
    caption: captionLight,
    overline: overlineLight,
  );

  static TextStyle headline1Light = TextStyle(
    fontFamily: 'Inter',
    fontSize: 3.34 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w500,
  );

  static TextStyle headline2Light = TextStyle(
    fontFamily: 'Inter',
    fontSize: 2.56 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w400,
  );

  static TextStyle headline3Light = TextStyle(
    fontFamily: 'Inter',
    fontSize: 2.12 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w400,
    color: primary,
  );

  static TextStyle subtitle1Light = TextStyle(
    fontFamily: 'Inter',
    fontSize: 1.78 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w400,
  );

  static TextStyle subtitle2Light = TextStyle(
    fontFamily: 'Inter',
    fontSize: 1.56 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w400,
  );

  static TextStyle body1Light = TextStyle(
    fontFamily: 'Inter',
    fontSize: 1.78 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w400,
  );

  static TextStyle body2Light = TextStyle(
    fontFamily: 'Inter',
    fontSize: 1.56 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w400,
  );

  static TextStyle buttonLight = TextStyle(
    fontFamily: 'Inter',
    fontSize: 1.56 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w500,
    color: neutral100,
  );

  static TextStyle captionLight = TextStyle(
    fontFamily: 'Inter',
    fontSize: 1.33 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w400,
    color: neutral80,
  );

  static TextStyle overlineLight = TextStyle(
    fontFamily: 'Inter',
    fontSize: 1.11 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.underline,
  );

  static Color neutral80 = Color(0xff616161);
  static Color neutral100 = Color(0xff0A0A0A);
  static Color primary = Color(0xff2094F3);
}
