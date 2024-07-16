import 'package:flutter/material.dart';
ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.white,primary: Colors.grey.shade200,
    secondary: Colors.grey.shade100,
      tertiary: Colors.cyan
  )
);
ThemeData darkMode =  ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade900,
    primary: Colors.grey.shade800,
      secondary: Colors.grey.shade700,
    tertiary: Colors.orange.shade800
  )
);