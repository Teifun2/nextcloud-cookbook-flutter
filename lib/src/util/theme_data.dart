import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  /// Light theme
  static final lightThemeData = ThemeData(
    hintColor: Colors.grey,
    colorScheme: lightColorSheme,
    inputDecorationTheme: inputdecoration,
    useMaterial3: true,
    extensions: [
      SnackBarThemes(
        colorScheme: lightColorSheme,
      ),
    ],
  );

  /// Dark theme
  static final darkThemeData = ThemeData(
    hintColor: Colors.grey,
    colorScheme: darkColorSheme,
    inputDecorationTheme: inputdecoration,
    useMaterial3: true,
    extensions: [
      SnackBarThemes(
        colorScheme: darkColorSheme,
      ),
    ],
  );

  static const nextCloudBlue = Color.fromRGBO(00, 130, 201, 1);

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

  static final snackbarTheme = SnackBarThemeData(
    backgroundColor: lightColorSheme.error,
    contentTextStyle: TextStyle(
      color: lightColorSheme.onError,
    ),
  );
}

@immutable
class SnackBarThemes extends ThemeExtension<SnackBarThemes> {
  const SnackBarThemes({
    required this.colorScheme,
  });

  final ColorScheme colorScheme;

  SnackBarThemeData get errorSnackBar => SnackBarThemeData(
        backgroundColor: colorScheme.errorContainer,
        contentTextStyle: TextStyle(
          color: colorScheme.onErrorContainer,
        ),
      );

  SnackBarThemeData get warningSnackBar => const SnackBarThemeData(
        backgroundColor: Colors.orange,
      );

  @override
  SnackBarThemes copyWith({ColorScheme? colorScheme}) => SnackBarThemes(
        colorScheme: colorScheme ?? this.colorScheme,
      );

  @override
  SnackBarThemes lerp(SnackBarThemes? other, double t) {
    if (other is! SnackBarThemes) {
      return this;
    }
    return SnackBarThemes(
      colorScheme: ColorScheme.lerp(colorScheme, other.colorScheme, t),
    );
  }

  @override
  String toString() => 'SnackBarThemes(colorScheme: $colorScheme)';
}
