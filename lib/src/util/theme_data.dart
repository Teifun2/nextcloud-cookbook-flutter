import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  /// Light theme
  static final lightThemeData = ThemeData(
    hintColor: Colors.grey,
    colorScheme: lightColorSheme,
    inputDecorationTheme: inputdecoration,
    useMaterial3: true,
  );

  /// Dark theme
  static final darkThemeData = ThemeData(
    hintColor: Colors.grey,
    colorScheme: darkColorSheme,
    inputDecorationTheme: inputdecoration,
    useMaterial3: true,
  );

  static const nextCloudBlue = Color.fromRGBO(00, 130, 201, 1.0);

  static final lightColorSheme = ColorScheme.fromSeed(
    seedColor: nextCloudBlue,
  );

  static final darkColorSheme = ColorScheme.fromSeed(
    seedColor: nextCloudBlue,
    brightness: Brightness.dark,
  );

  static const inputdecoration = InputDecorationTheme(
    border: OutlineInputBorder(),
    floatingLabelBehavior: FloatingLabelBehavior.always,
  );
}
