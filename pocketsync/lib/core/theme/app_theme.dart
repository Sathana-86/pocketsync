// core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF7F7F5);
  static const Color lightSurfaceVariant = Color(0xFFF0EFE9);
  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF5A5A5A);
  static const Color lightTextTertiary = Color(0xFF9A9A9A);
  static const Color lightBorder = Color(0x1A000000); // rgba(0,0,0,0.1)
  static const Color lightBorderStrong = Color(0x2E000000); // rgba(0,0,0,0.18)
  static const Color lightAccent = Color(0xFF7F77DD);
  static const Color lightAccentLight = Color(0xFFEEEDFE);
  static const Color lightAccentDark = Color(0xFF534AB7);
  static const Color lightTeal = Color(0xFF1D9E75);
  static const Color lightTealLight = Color(0xFFE1F5EE);
  static const Color lightAmber = Color(0xFFBA7517);
  static const Color lightAmberLight = Color(0xFFFAEEDA);
  static const Color lightRed = Color(0xFFE24B4A);
  static const Color lightRedLight = Color(0xFFFCEBEB);
  static const Color lightGreen = Color(0xFF639922);
  static const Color lightGreenLight = Color(0xFFEAF3DE);
  static const Color lightCard = Color(0xFFFFFFFF);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF18181C);
  static const Color darkSurface = Color(0xFF22222A);
  static const Color darkSurfaceVariant = Color(0xFF2A2A34);
  static const Color darkTextPrimary = Color(0xFFF0F0EF);
  static const Color darkTextSecondary = Color(0xFFA0A09A);
  static const Color darkTextTertiary = Color(0xFF606060);
  static const Color darkBorder = Color(0x17FFFFFF); // rgba(255,255,255,0.09)
  static const Color darkBorderStrong = Color(0x29FFFFFF); // rgba(255,255,255,0.16)
  static const Color darkAccent = Color(0xFFAFA9EC);
  static const Color darkAccentLight = Color(0xFF3C3489);
  static const Color darkAccentDark = Color(0xFFCECBF6);
  static const Color darkTeal = Color(0xFF5DCAA5);
  static const Color darkTealLight = Color(0xFF085041);
  static const Color darkAmber = Color(0xFFEF9F27);
  static const Color darkAmberLight = Color(0xFF633806);
  static const Color darkRed = Color(0xFFF09595);
  static const Color darkRedLight = Color(0xFF791F1F);
  static const Color darkGreen = Color(0xFF97C459);
  static const Color darkGreenLight = Color(0xFF27500A);
  static const Color darkCard = Color(0xFF22222A);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: lightAccent,
        secondary: lightTeal,
        tertiary: lightAmber,
        error: lightRed,
        surface: lightSurface,
        background: lightBackground,
      ),

      // Scaffold
      scaffoldBackgroundColor: lightBackground,

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBackground,
        foregroundColor: lightTextPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: lightTextPrimary,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(12),
                     side: BorderSide(color: lightBorder, width: 0.5),
                   ),
        margin: EdgeInsets.zero,
      ),
      // Text Themes
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: lightTextPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: lightTextPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: lightTextPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: lightTextPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: lightTextPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: lightTextPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 14,
          color: lightTextPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 13,
          color: lightTextSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 11,
          color: lightTextTertiary,
        ),
        labelLarge: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: lightTextSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          color: lightTextTertiary,
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: lightBorderStrong, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: lightBorderStrong, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: lightAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: lightRed, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        labelStyle: const TextStyle(fontSize: 11, color: lightTextSecondary),
        hintStyle: const TextStyle(fontSize: 13, color: lightTextTertiary),
        errorStyle: const TextStyle(fontSize: 10, color: lightRed),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightTextPrimary,
          side: BorderSide(color: lightBorderStrong, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lightAccent,
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightBackground,
        selectedItemColor: lightAccent,
        unselectedItemColor: lightTextTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 11),
        unselectedLabelStyle: TextStyle(fontSize: 11),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: lightBorder,
        thickness: 0.5,
        space: 0,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: lightTextSecondary,
        size: 20,
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: lightTextPrimary,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 14,
          color: lightTextSecondary,
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: lightSurface,
        labelStyle: const TextStyle(fontSize: 11, color: lightTextSecondary),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: lightBorderStrong),
        ),
      ),

      // Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        indicatorColor: lightAccent,
        labelColor: lightTextPrimary,
        unselectedLabelColor: lightTextTertiary,
        labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: darkAccent,
        secondary: darkTeal,
        tertiary: darkAmber,
        error: darkRed,
        surface: darkSurface,
        background: darkBackground,
      ),

      // Scaffold
      scaffoldBackgroundColor: darkBackground,

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: darkTextPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: darkBorder, width: 0.5),
        ),
        margin: EdgeInsets.zero,
      ),

      // Text Themes
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: darkTextPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: darkTextPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: darkTextPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: darkTextPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 14,
          color: darkTextPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 13,
          color: darkTextSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 11,
          color: darkTextTertiary,
        ),
        labelLarge: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: darkTextSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          color: darkTextTertiary,
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: darkBorderStrong, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: darkBorderStrong, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: darkAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: darkRed, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        labelStyle: const TextStyle(fontSize: 11, color: darkTextSecondary),
        hintStyle: const TextStyle(fontSize: 13, color: darkTextTertiary),
        errorStyle: const TextStyle(fontSize: 10, color: darkRed),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkAccent,
          foregroundColor: darkTextPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkTextPrimary,
          side: BorderSide(color: darkBorderStrong, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkAccent,
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkBackground,
        selectedItemColor: darkAccent,
        unselectedItemColor: darkTextTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 11),
        unselectedLabelStyle: TextStyle(fontSize: 11),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: darkBorder,
        thickness: 0.5,
        space: 0,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: darkTextSecondary,
        size: 20,
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 14,
          color: darkTextSecondary,
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: darkSurface,
        labelStyle: const TextStyle(fontSize: 11, color: darkTextSecondary),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: darkBorderStrong),
        ),
      ),

      // Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        indicatorColor: darkAccent,
        labelColor: darkTextPrimary,
        unselectedLabelColor: darkTextTertiary,
        labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }
}

// Extension for easy access to theme colors throughout the app
extension CustomTheme on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // Custom colors
  Color get accentColor => isDarkMode ? AppTheme.darkAccent : AppTheme.lightAccent;
  Color get accentLight => isDarkMode ? AppTheme.darkAccentLight : AppTheme.lightAccentLight;
  Color get accentDark => isDarkMode ? AppTheme.darkAccentDark : AppTheme.lightAccentDark;
  Color get tealColor => isDarkMode ? AppTheme.darkTeal : AppTheme.lightTeal;
  Color get tealLight => isDarkMode ? AppTheme.darkTealLight : AppTheme.lightTealLight;
  Color get amberColor => isDarkMode ? AppTheme.darkAmber : AppTheme.lightAmber;
  Color get amberLight => isDarkMode ? AppTheme.darkAmberLight : AppTheme.lightAmberLight;
  Color get redColor => isDarkMode ? AppTheme.darkRed : AppTheme.lightRed;
  Color get redLight => isDarkMode ? AppTheme.darkRedLight : AppTheme.lightRedLight;
  Color get greenColor => isDarkMode ? AppTheme.darkGreen : AppTheme.lightGreen;
  Color get greenLight => isDarkMode ? AppTheme.darkGreenLight : AppTheme.lightGreenLight;

  // Surface colors
  Color get surfaceColor => isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface;
  Color get surfaceVariant => isDarkMode ? AppTheme.darkSurfaceVariant : AppTheme.lightSurfaceVariant;

  // Text colors
  Color get textPrimary => isDarkMode ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary;
  Color get textSecondary => isDarkMode ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;
  Color get textTertiary => isDarkMode ? AppTheme.darkTextTertiary : AppTheme.lightTextTertiary;

  // Border colors
  Color get borderColor => isDarkMode ? AppTheme.darkBorder : AppTheme.lightBorder;
  Color get borderStrong => isDarkMode ? AppTheme.darkBorderStrong : AppTheme.lightBorderStrong;
}