import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static const Color lightPrimary = Color(0xFF0D47A1); // Blue 900
  static const Color lightPrimaryVariant = Color(0xFF1565C0); // Blue 800
  static const Color lightSecondary = Color(0xFF03A9F4); // Light Blue
  static const Color lightSecondaryVariant = Color(0xFF0288D1);
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightError = Color(0xFFD32F2F);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightOnBackground = Color(0xFF000000);
  static const Color lightOnSurface = Color(0xFF000000);
  static const Color lightOnError = Color(0xFFFFFFFF);

  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFF1976D2); // Blue 700
  static const Color darkPrimaryVariant = Color(0xFF1565C0); // Blue 800
  static const Color darkSecondary = Color(0xFF29B6F6); // Light Blue 400
  static const Color darkSecondaryVariant = Color(0xFF0288D1);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkError = Color(0xFFCF6679);
  static const Color darkOnPrimary = Color(0xFFFFFFFF);
  static const Color darkOnSecondary = Color(0xFF000000);
  static const Color darkOnBackground = Color(0xFFFFFFFF);
  static const Color darkOnSurface = Color(0xFFFFFFFF);
  static const Color darkOnError = Color(0xFF000000);

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: "Teachers",

    colorScheme: const ColorScheme.light(
      primary: lightPrimary,
      primaryContainer: lightPrimaryVariant,
      secondary: lightSecondary,
      secondaryContainer: lightSecondaryVariant,
      surface: lightSurface,
      error: lightError,
      onPrimary: lightOnPrimary,
      onSecondary: lightOnSecondary,
      onSurface: lightOnSurface,
      onError: lightOnError,
    ),

    scaffoldBackgroundColor: lightBackground,

    appBarTheme: const AppBarTheme(
      backgroundColor: lightPrimary,
      foregroundColor: lightOnPrimary,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: lightOnPrimary),
    ),

    cardTheme: CardThemeData(
      color: lightSurface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightPrimary,
        foregroundColor: lightOnPrimary,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: lightPrimary),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: lightPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: lightError),
      ),
      prefixIconColor: Colors.grey.shade600,
      suffixIconColor: Colors.grey.shade600,
    ),

    iconTheme: const IconThemeData(color: lightPrimary),

    dividerTheme: DividerThemeData(color: Colors.grey.shade300, thickness: 1),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.bold,
        color: lightOnBackground,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        color: lightOnBackground,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: lightOnBackground,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: lightOnBackground,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: lightOnBackground,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: lightOnBackground,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: lightOnBackground,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: lightOnBackground,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: lightOnBackground,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: lightOnBackground,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: lightOnBackground,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: lightOnBackground,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: lightOnBackground,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: lightOnBackground,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: lightOnBackground,
      ),
    ),

    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: "Teachers",

    colorScheme: const ColorScheme.dark(
      primary: darkPrimary,
      primaryContainer: darkPrimaryVariant,
      secondary: darkSecondary,
      secondaryContainer: darkSecondaryVariant,
      surface: darkSurface,
      error: darkError,
      onPrimary: darkOnPrimary,
      onSecondary: darkOnSecondary,
      onSurface: darkOnSurface,
      onError: darkOnError,
    ),

    scaffoldBackgroundColor: darkBackground,

    appBarTheme: const AppBarTheme(
      backgroundColor: darkSurface,
      foregroundColor: darkOnSurface,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: darkOnSurface),
    ),

    cardTheme: CardThemeData(
      color: darkSurface,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimary,
        foregroundColor: darkOnPrimary,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: darkSecondary),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF424242)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: darkPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: darkError),
      ),
      prefixIconColor: Colors.grey.shade400,
      suffixIconColor: Colors.grey.shade400,
    ),

    iconTheme: const IconThemeData(color: darkSecondary),

    dividerTheme: const DividerThemeData(
      color: Color(0xFF424242),
      thickness: 1,
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.bold,
        color: darkOnBackground,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        color: darkOnBackground,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: darkOnBackground,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: darkOnBackground,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: darkOnBackground,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: darkOnBackground,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: darkOnBackground,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: darkOnBackground,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: darkOnBackground,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: darkOnBackground,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: darkOnBackground,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: darkOnBackground,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: darkOnBackground,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: darkOnBackground,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: darkOnBackground,
      ),
    ),

    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
