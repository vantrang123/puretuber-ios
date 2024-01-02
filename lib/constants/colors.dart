import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // this basically makes it so you can't instantiate this class

  static const Map<int, Color> accentColor = const <int, Color>{
    50: Colors.redAccent,
    100: Colors.redAccent,
    200: Colors.redAccent,
    300: Colors.redAccent,
    400: Colors.redAccent,
    500: Colors.redAccent,
    600: Colors.redAccent,
    700: Colors.redAccent,
    800: Colors.redAccent,
    900: Colors.redAccent
  };

  static const Color backgroundColor = Color(0xFF081828);
  static const Color textColor = Color(0xffB8B8B8);
  static const Color textColorGray = Color(0xffB8B8B8);
  static const Color textHint = Color(0xff6B6B6B);
}
