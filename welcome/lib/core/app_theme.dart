import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: const Color.fromARGB(255, 55, 114, 162),
    secondary: const Color.fromARGB(255, 103, 98, 104),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: const Color.fromARGB(255, 102, 193, 161),
    secondary: const Color.fromARGB(255, 103, 98, 104),
  ),
);
