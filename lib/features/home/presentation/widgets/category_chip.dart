import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_colors.dart';

/// Premium category chip with selection animation
class CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.icon,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: AppConstants.defaultAnimationDuration,
        curve: AppConstants.smoothCurve,
        margin: const EdgeInsets.only(right: AppConstants.spacingSm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd,
          vertical: AppConstants.spacingSm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : context.surfaceVariant,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusXl),
          border: Border.all(
            color: isSelected ? AppColors.primary : context.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: AppConstants.borderRadiusMd,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppConstants.iconSizeSm,
              color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
            ),
            const SizedBox(width: AppConstants.spacingXs),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension CategoryChipExtension on BuildContext {
  Color get surfaceVariant => Theme.of(this).colorScheme.surfaceContainerHighest;
}
