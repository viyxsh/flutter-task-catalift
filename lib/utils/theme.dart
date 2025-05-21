import 'package:flutter/material.dart';

class AppTheme {
  // App colors
  static const Color primaryColor = Color(0xFF151965);
  static const Color accentColor = Color(0xFF7ED9C3);
  static const Color secondaryColor = Color(0xFFF5F5F7);
  static const Color textColor = Color(0xFF333333);
  static const Color lightTextColor = Color(0xFF8E8E93);
  static const Color whiteColor = Colors.white;
  static const Color starColor = Color(0xFFFFC107);

  // Font sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeRegular = 14.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeExtraLarge = 24.0;

  // Spacing values
  static const double spacingSmall = 8.0;
  static const double spacingRegular = 16.0;
  static const double spacingMedium = 24.0;
  static const double spacingLarge = 32.0;

  // Border radius
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusRegular = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusExtraLarge = 24.0;

  // Button styles
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: whiteColor,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadiusExtraLarge),
    ),
  );

  static final ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: whiteColor,
    foregroundColor: primaryColor,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadiusExtraLarge),
      side: const BorderSide(color: primaryColor),
    ),
  );

  static final ThemeData themeData = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: whiteColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteColor,
      foregroundColor: primaryColor,
      elevation: 0,
      centerTitle: true,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: primaryColor,
      secondary: accentColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: primaryButtonStyle,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: fontSizeExtraLarge,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      displayMedium: TextStyle(
        fontSize: fontSizeLarge,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      bodyLarge: TextStyle(
        fontSize: fontSizeMedium,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontSize: fontSizeRegular,
        color: textColor,
      ),
      bodySmall: TextStyle(
        fontSize: fontSizeSmall,
        color: lightTextColor,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusRegular),
      ),
    ),
  );
}