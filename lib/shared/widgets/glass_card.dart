import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

/// Premium glassmorphism card widget with blur effect
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final Color? color;
  final double? blur;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final bool isGradient;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.borderRadius,
    this.color,
    this.blur,
    this.border,
    this.boxShadow,
    this.isGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = color ?? context.glass;
    final themeBorder = border ?? Border.all(
      color: context.glassBorder,
      width: 1,
    );

    Widget content = ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.borderRadiusLg),
      child: Container(
        width: width,
        height: height,
        padding: padding ?? const EdgeInsets.all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: isGradient ? null : themeColor,
          gradient: isGradient ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeColor.withOpacity(0.8),
              themeColor.withOpacity(0.4),
            ],
          ) : null,
          borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.borderRadiusLg),
          border: themeBorder,
          boxShadow: boxShadow ?? [
            BoxShadow(
              color: context.brightness == Brightness.dark
                  ? AppColors.shadowDark
                  : AppColors.shadowLight,
              blurRadius: AppConstants.borderRadiusLg,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blur ?? 10,
            sigmaY: blur ?? 10,
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.borderRadiusLg),
        child: content,
      );
    }

    return content;
  }
}

extension GlassCardExtension on BuildContext {
  Brightness get brightness => Theme.of(this).brightness;
}
