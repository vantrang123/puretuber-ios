import 'package:flutter/material.dart';

import 'colors.dart';

final ThemeData themeData = new ThemeData(
    primaryColor: AppColors.accentColor[500],
    colorScheme: ColorScheme.fromSwatch(
        primarySwatch: MaterialColor(
            AppColors.accentColor[500]!.value, AppColors.accentColor))
        .copyWith(
        secondary: AppColors.accentColor[500],
        brightness: Brightness.light));

final ThemeData themeDataDark = ThemeData(
    primaryColor: AppColors.accentColor[500],
    scaffoldBackgroundColor: Color(0xff1d1d1d),
    colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: AppColors.accentColor[500], brightness: Brightness.dark));