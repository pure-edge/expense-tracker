import 'package:flutter/material.dart';

class GlobalThemeData {
  static final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.green,
    brightness: Brightness.light,
  );

  static final ThemeData lightThemeData = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(colorScheme.primary),
        foregroundColor: WidgetStatePropertyAll(colorScheme.onPrimary),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
      titleTextStyle:
          const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
    ),
  );
}
