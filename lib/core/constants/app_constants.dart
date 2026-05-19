import 'package:flutter/animation.dart';

/// App-wide constants for TableVerse
class AppConstants {
  AppConstants._(); 

  // ==================== Animation ====================
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);
  static const Duration pageTransitionDuration = Duration(milliseconds: 400);
  
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.bounceOut;
  static const Curve smoothCurve = Curves.easeOutCubic;
  static const Curve springCurve = Curves.elasticOut;

  // ==================== Layout ====================
  static const double borderRadiusSm = 8.0;
  static const double borderRadiusMd = 12.0;
  static const double borderRadiusLg = 16.0;
  static const double borderRadiusXl = 20.0;
  static const double borderRadiusXxl = 24.0;

  static const double spacingXxs = 4.0;
  static const double spacingXs = 8.0;
  static const double spacingSm = 12.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;
  static const double spacingXxxl = 64.0;

  static const double iconSizeSm = 16.0;
  static const double iconSizeMd = 24.0;
  static const double iconSizeLg = 32.0;
  static const double iconSizeXl = 48.0;

  // ==================== Typography ====================
  static const double fontSizeXs = 12.0;
  static const double fontSizeSm = 14.0;
  static const double fontSizeMd = 16.0;
  static const double fontSizeLg = 18.0;
  static const double fontSizeXl = 20.0;
  static const double fontSizeXxl = 24.0;
  static const double fontSizeXxxl = 32.0;
  static const double fontSizeDisplay = 48.0;

  // ==================== Elevation ====================
  static const double elevationNone = 0.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  static const double elevationXl = 16.0;

  // ==================== Image ====================
  static const double imageQuality = 0.8;
  static const int maxImageWidth = 1920;
  static const int maxImageHeight = 1080;

  // ==================== AR ====================
  static const double arDefaultScale = 1.0;
  static const double arMinScale = 0.5;
  static const double arMaxScale = 3.0;
  static const double arRotationSensitivity = 0.01;

  // ==================== Pagination ====================
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // ==================== Storage ====================
  static const String imagesPath = 'images';
  static const String modelsPath = 'models';
  static const String avatarsPath = 'avatars';

  // ==================== Validation ====================
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const int maxNameLength = 100;
  static const int maxDescriptionLength = 500;
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB

  // ==================== Debounce ====================
  static const Duration searchDebounce = Duration(milliseconds: 500);
  static const Duration autoSaveDebounce = Duration(milliseconds: 1000);

  // ==================== Cache ====================
  static const Duration imageCacheDuration = Duration(days: 7);
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB

  // ==================== Performance ====================
  static const int targetFPS = 60;
  static const Duration frameTime = Duration(milliseconds: 16);
}
