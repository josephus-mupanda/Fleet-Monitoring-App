import 'package:flutter/material.dart';
import '../config/app_config.dart';

class TextStyles {
  static const TextStyle headline1 = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    fontFamily: AppConfig.fontFamily,
    color: Colors.black,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    fontFamily: AppConfig.fontFamily,
    color: Colors.black,
  );

  static const TextStyle bodyText1 = TextStyle(
    fontSize: 16.0,
    fontFamily: AppConfig.fontFamily,
    color: Colors.black,
  );

  static const TextStyle bodyText2 = TextStyle(
    fontSize: 14.0,
    fontFamily: AppConfig.fontFamily,
    color: Colors.black,
  );

}
