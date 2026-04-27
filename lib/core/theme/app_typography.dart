import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Premium iOS-inspired typography system for TableVerse
class AppTypography {
  AppTypography._();

  // ==================== Font Families ====================
  static const String primaryFont = 'SF Pro Display';
  static const String secondaryFont = 'SF Pro Text';

  // ==================== Text Styles - Light Mode ====================
  static const TextStyle _displayLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: AppConstants.fontSizeDisplay,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.1,
  );

  static const TextStyle _displayMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: AppConstants.fontSizeXxxl,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.2,
  );

  static const TextStyle _displaySmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: AppConstants.fontSizeXxl,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static const TextStyle _headlineLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: AppConstants.fontSizeXl,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static const TextStyle _headlineMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: AppConstants.fontSizeLg,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    height: 1.4,
  );

  static const TextStyle _headlineSmall = TextStyle(
    fontFamily: secondaryFont,
    fontSize: AppConstants.fontSizeMd,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.5,
  );

  static const TextStyle _titleLarge = TextStyle(
    fontFamily: secondaryFont,
    fontSize: AppConstants.fontSizeLg,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.4,
  );

  static const TextStyle _titleMedium = TextStyle(
    fontFamily: secondaryFont,
    fontSize: AppConstants.fontSizeMd,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.5,
  );

  static const TextStyle _titleSmall = TextStyle(
    fontFamily: secondaryFont,
    fontSize: AppConstants.fontSizeSm,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.5,
  );

  static const TextStyle _bodyLarge = TextStyle(
    fontFamily: secondaryFont,
    fontSize: AppConstants.fontSizeMd,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.5,
  );

  static const TextStyle _bodyMedium = TextStyle(
    fontFamily: secondaryFont,
    fontSize: AppConstants.fontSizeSm,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.5,
  );

  static const TextStyle _bodySmall = TextStyle(
    fontFamily: secondaryFont,
    fontSize: AppConstants.fontSizeXs,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 1.4,
  );

  static const TextStyle _labelLarge = TextStyle(
    fontFamily: secondaryFont,
    fontSize: AppConstants.fontSizeSm,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.4,
  );

  static const TextStyle _labelMedium = TextStyle(
    fontFamily: secondaryFont,
    fontSize: AppConstants.fontSizeXs,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    height: 1.3,
  );

  static const TextStyle _labelSmall = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 10.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    height: 1.3,
  );

  // ==================== Light Theme Text Theme ====================
  static TextTheme get lightTextTheme => TextTheme(
    displayLarge: _displayLarge.copyWith(color: const Color(0xFF111827)),
    displayMedium: _displayMedium.copyWith(color: const Color(0xFF111827)),
    displaySmall: _displaySmall.copyWith(color: const Color(0xFF111827)),
    headlineLarge: _headlineLarge.copyWith(color: const Color(0xFF111827)),
    headlineMedium: _headlineMedium.copyWith(color: const Color(0xFF111827)),
    headlineSmall: _headlineSmall.copyWith(color: const Color(0xFF111827)),
    titleLarge: _titleLarge.copyWith(color: const Color(0xFF111827)),
    titleMedium: _titleMedium.copyWith(color: const Color(0xFF111827)),
    titleSmall: _titleSmall.copyWith(color: const Color(0xFF111827)),
    bodyLarge: _bodyLarge.copyWith(color: const Color(0xFF111827)),
    bodyMedium: _bodyMedium.copyWith(color: const Color(0xFF6B7280)),
    bodySmall: _bodySmall.copyWith(color: const Color(0xFF9CA3AF)),
    labelLarge: _labelLarge.copyWith(color: const Color(0xFF6B7280)),
    labelMedium: _labelMedium.copyWith(color: const Color(0xFF9CA3AF)),
    labelSmall: _labelSmall.copyWith(color: const Color(0xFF9CA3AF)),
  );

  // ==================== Dark Theme Text Theme ====================
  static TextTheme get darkTextTheme => TextTheme(
    displayLarge: _displayLarge.copyWith(color: const Color(0xFFFFFFFF)),
    displayMedium: _displayMedium.copyWith(color: const Color(0xFFFFFFFF)),
    displaySmall: _displaySmall.copyWith(color: const Color(0xFFFFFFFF)),
    headlineLarge: _headlineLarge.copyWith(color: const Color(0xFFFFFFFF)),
    headlineMedium: _headlineMedium.copyWith(color: const Color(0xFFFFFFFF)),
    headlineSmall: _headlineSmall.copyWith(color: const Color(0xFFFFFFFF)),
    titleLarge: _titleLarge.copyWith(color: const Color(0xFFFFFFFF)),
    titleMedium: _titleMedium.copyWith(color: const Color(0xFFFFFFFF)),
    titleSmall: _titleSmall.copyWith(color: const Color(0xFFFFFFFF)),
    bodyLarge: _bodyLarge.copyWith(color: const Color(0xFFFFFFFF)),
    bodyMedium: _bodyMedium.copyWith(color: const Color(0xFFA3A3A3)),
    bodySmall: _bodySmall.copyWith(color: const Color(0xFF737373)),
    labelLarge: _labelLarge.copyWith(color: const Color(0xFFA3A3A3)),
    labelMedium: _labelMedium.copyWith(color: const Color(0xFF737373)),
    labelSmall: _labelSmall.copyWith(color: const Color(0xFF737373)),
  );

  // ==================== Helper Methods ====================
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }
}
