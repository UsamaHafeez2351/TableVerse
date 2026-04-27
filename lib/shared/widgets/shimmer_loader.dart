import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

/// Premium shimmer loading widget for skeleton screens
class ShimmerLoader extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;

  const ShimmerLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.borderRadiusMd),
        color: context.brightness == Brightness.dark
            ? AppColors.darkSurfaceVariant
            : AppColors.lightSurfaceVariant,
      ),
    );
  }
}

/// Shimmer loading card with multiple shimmer blocks
class ShimmerCard extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final bool showImage;
  final bool showTitle;
  final bool showSubtitle;
  final bool showButton;
  final int subtitleLines;

  const ShimmerCard({
    super.key,
    this.padding,
    this.showImage = true,
    this.showTitle = true,
    this.showSubtitle = true,
    this.showButton = false,
    this.subtitleLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.brightness == Brightness.dark
          ? AppColors.darkSurfaceVariant
          : AppColors.lightSurfaceVariant,
      highlightColor: context.brightness == Brightness.dark
          ? AppColors.darkSurface
          : AppColors.lightSurface,
      period: const Duration(milliseconds: 1500),
      child: Container(
        padding: padding ?? const EdgeInsets.all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: context.brightness == Brightness.dark
              ? AppColors.darkSurfaceVariant
              : AppColors.lightSurfaceVariant,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showImage)
              ShimmerLoader(
                width: double.infinity,
                height: 150,
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
              ),
            if (showImage) const SizedBox(height: AppConstants.spacingMd),
            if (showTitle)
              ShimmerLoader(
                width: double.infinity,
                height: 20,
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusSm),
              ),
            if (showTitle && showSubtitle)
              const SizedBox(height: AppConstants.spacingSm),
            if (showSubtitle) ...[
              for (int i = 0; i < subtitleLines; i++) ...[
                ShimmerLoader(
                  width: i == subtitleLines - 1 ? double.infinity * 0.6 : double.infinity,
                  height: 14,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusSm),
                ),
                if (i < subtitleLines - 1) const SizedBox(height: AppConstants.spacingXs),
              ],
            ],
            if (showButton) const SizedBox(height: AppConstants.spacingMd),
            if (showButton)
              ShimmerLoader(
                width: 100,
                height: 36,
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
              ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer loading list for multiple items
class ShimmerList extends StatelessWidget {
  final int itemCount;
  final EdgeInsetsGeometry? padding;

  const ShimmerList({
    super.key,
    required this.itemCount,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding ?? const EdgeInsets.all(AppConstants.spacingMd),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: AppConstants.spacingMd),
      itemBuilder: (_, __) => const ShimmerCard(
        showImage: true,
        showTitle: true,
        showSubtitle: true,
        subtitleLines: 2,
      ),
    );
  }
}

extension ShimmerExtension on BuildContext {
  Brightness get brightness => Theme.of(this).brightness;
}
