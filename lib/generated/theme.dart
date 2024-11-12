import 'package:flutter/material.dart';

class AppColors {
  // Define colors
  static const Color primaryColor = Color(0xFF3D3E28);
  // static const Color secondaryColor = Color(0xFFFF5722);
  static const Color surfaceColor =
      Colors.white; // Use for backgrounds and surfaces
  static const Color textColor = Color(0xFF3D3E28);
  static const Color errorColor = Colors.redAccent;
}

class AppThemes {
  // Define light theme
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.surfaceColor,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      // secondary: AppColors.secondaryColor,
      surface: AppColors.surfaceColor, // Use surface instead of background
      error: AppColors.errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textColor, // Use onSurface instead of onBackground
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: AppColors.textColor,
        fontFamily: 'PlayfairDisplay',
      ),
      bodyMedium: TextStyle(
        color: AppColors.textColor,
        fontFamily: 'PermanentMarker',
      ),
      headlineLarge: TextStyle(
        color: Colors.white,
        fontFamily: 'PlayfairDisplay',

      )
    ),
  );
}
