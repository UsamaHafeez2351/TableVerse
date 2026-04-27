import 'package:flutter/material.dart';

/// Premium iOS-inspired color palette for TableVerse
/// Supports both light and dark modes with carefully crafted colors
class AppColors {
  AppColors._();

  // ==================== Brand Colors ====================
  static const Color primary = Color(0xFF6366F1); // Indigo 500
  static const Color primaryDark = Color(0xFF4F46E5); // Indigo 600
  static const Color primaryLight = Color(0xFF818CF8); // Indigo 400
  
  static const Color secondary = Color(0xFFF59E0B); // Amber 500
  static const Color secondaryDark = Color(0xFFD97706); // Amber 600
  static const Color secondaryLight = Color(0xFFFBBF24); // Amber 400

  // ==================== Light Mode Colors ====================
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF3F4F6);
  
  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightTextTertiary = Color(0xFF9CA3AF);
  
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightBorderLight = Color(0xFFF3F4F6);

  // ==================== Dark Mode Colors ====================
  static const Color darkBackground = Color(0xFF0F0F0F);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color darkSurfaceVariant = Color(0xFF262626);
  
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFA3A3A3);
  static const Color darkTextTertiary = Color(0xFF737373);
  
  static const Color darkBorder = Color(0xFF262626);
  static const Color darkBorderLight = Color(0xFF404040);

  // ==================== Semantic Colors ====================
  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color successLight = Color(0xFFD1FAE5); // Emerald 100
  static const Color successDark = Color(0xFF059669); // Emerald 600
  
  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color errorLight = Color(0xFFFEE2E2); // Red 100
  static const Color errorDark = Color(0xFFDC2626); // Red 600
  
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color warningLight = Color(0xFFFEF3C7); // Amber 100
  static const Color warningDark = Color(0xFFD97706); // Amber 600
  
  static const Color info = Color(0xFF3B82F6); // Blue 500
  static const Color infoLight = Color(0xFFDBEAFE); // Blue 100
  static const Color infoDark = Color(0xFF2563EB); // Blue 600

  // ==================== Glassmorphism Colors ====================
  static const Color glassLight = Color(0x80FFFFFF);
  static const Color glassDark = Color(0x801A1A1A);
  static const Color glassBorderLight = Color(0x1A000000);
  static const Color glassBorderDark = Color(0x33FFFFFF);

  // ==================== Shadow Colors ====================
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowDark = Color(0x33000000);
  static const Color shadowColored = Color(0x336366F1);

  // ==================== Overlay Colors ====================
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40FFFFFF);

  // ==================== Gradient Colors ====================
  static const List<Color> primaryGradient = [
    primary,
    primaryLight,
  ];
  
  static const List<Color> secondaryGradient = [
    secondary,
    secondaryLight,
  ];
  
  static const List<Color> darkGradient = [
    Color(0xFF1A1A1A),
    Color(0xFF0F0F0F),
  ];

  // ==================== Category Colors ====================
  static const Color categoryStarters = Color(0xFFEF4444);
  static const Color categoryMainCourse = Color(0xFFF59E0B);
  static const Color categoryDesserts = Color(0xFFEC4899);
  static const Color categoryBeverages = Color(0xFF3B82F6);
  static const Color categorySnacks = Color(0xFF10B981);
}

/// Extension for theme-aware color access
extension AppColorsExtension on BuildContext {
  Color get surface => Theme.of(this).colorScheme.surface;
  Color get onSurface => Theme.of(this).colorScheme.onSurface;
  Color get primary => Theme.of(this).colorScheme.primary;
  Color get secondary => Theme.of(this).colorScheme.secondary;
  Color get error => Theme.of(this).colorScheme.error;
  Color get textPrimary => Theme.of(this).textTheme.bodyLarge?.color ?? Colors.black;
  Color get textSecondary => Theme.of(this).textTheme.bodyMedium?.color ?? Colors.grey;
  
  Color get border => Theme.of(this).brightness == Brightness.dark
      ? AppColors.darkBorder
      : AppColors.lightBorder;
  
  Color get borderLight => Theme.of(this).brightness == Brightness.dark
      ? AppColors.darkBorderLight
      : AppColors.lightBorderLight;
  
  Color get glass => Theme.of(this).brightness == Brightness.dark
      ? AppColors.glassDark
      : AppColors.glassLight;
  
  Color get glassBorder => Theme.of(this).brightness == Brightness.dark
      ? AppColors.glassBorderDark
      : AppColors.glassBorderLight;
}
