import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  // Default color value
  Color color;

  // Uso de late para inicializar as propriedades posteriormente
  late ColorScheme colorScheme;
  late ColorScheme colorSchemeDark;
  late ThemeData customTheme;
  late ThemeData customThemeDark;

  CustomTheme({required this.color}) {
    colorScheme = ColorScheme.fromSeed(
      seedColor: color,
      brightness: Brightness.light,
    );

    colorSchemeDark = ColorScheme.fromSeed(
      seedColor: color,
      brightness: Brightness.dark,
    );

    customTheme = ThemeData(
      colorScheme: colorScheme,
      fontFamily: GoogleFonts.montserrat().fontFamily,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        toolbarHeight: 100,
        backgroundColor: colorScheme.primary,
        titleTextStyle: GoogleFonts.lobster(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: colorScheme.onPrimary,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onPrimary,
          size: 36,
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.secondaryContainer,
        shadowColor: colorScheme.onSurface,
        elevation: 5,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );

    customThemeDark = ThemeData(
      colorScheme: colorSchemeDark,
      fontFamily: GoogleFonts.montserrat().fontFamily,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        toolbarHeight: 100,
        backgroundColor: colorSchemeDark.onPrimary,
        titleTextStyle: GoogleFonts.lobster(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: colorSchemeDark.primary,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onPrimary,
          size: 36,
        ),
      ),
      cardTheme: CardThemeData(
        color: colorSchemeDark.secondaryContainer,
        shadowColor: colorSchemeDark.onSurface,
        elevation: 5,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}