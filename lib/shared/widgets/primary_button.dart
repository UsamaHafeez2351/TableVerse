import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';

/// Premium primary button with haptic feedback and smooth animations
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final bool isOutlined;
  final bool isSecondary;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.isOutlined = false,
    this.isSecondary = false,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.width,
    this.height,
    this.borderRadius,
    this.icon,
    this.padding,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor = backgroundColor ?? 
        (isSecondary ? AppColors.secondary : AppColors.primary);
    final effectiveTextColor = textColor ?? Colors.white;
    final effectiveBorderColor = borderColor ?? effectiveBackgroundColor;

    Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null && !isLoading) ...[
          Icon(icon, size: AppConstants.iconSizeSm),
          const SizedBox(width: AppConstants.spacingXs),
        ],
        if (isLoading)
          SizedBox(
            width: AppConstants.iconSizeSm,
            height: AppConstants.iconSizeSm,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOutlined ? effectiveBackgroundColor : effectiveTextColor,
              ),
            ),
          )
        else
          Text(
            text,
            style: textStyle ?? theme.textTheme.labelLarge?.copyWith(
              color: isOutlined ? effectiveBackgroundColor : effectiveTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );

    return SizedBox(
      width: width,
      height: height ?? 48,
      child: AnimatedOpacity(
        duration: AppConstants.fastAnimationDuration,
        opacity: isDisabled ? 0.5 : 1.0,
        child: ElevatedButton(
          onPressed: (isDisabled || isLoading) ? null : () {
            HapticFeedback.lightImpact();
            onPressed?.call();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isOutlined ? Colors.transparent : effectiveBackgroundColor,
            foregroundColor: isOutlined ? effectiveBackgroundColor : effectiveTextColor,
            elevation: isOutlined ? 0 : null,
            padding: padding ?? const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingLg,
              vertical: AppConstants.spacingMd,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? AppConstants.borderRadiusMd,
              ),
              side: isOutlined 
                  ? BorderSide(color: effectiveBorderColor, width: 1.5)
                  : BorderSide.none,
            ),
            disabledBackgroundColor: isOutlined 
                ? Colors.transparent 
                : effectiveBackgroundColor.withOpacity(0.5),
            disabledForegroundColor: isOutlined 
                ? effectiveBackgroundColor.withOpacity(0.5)
                : effectiveTextColor.withOpacity(0.5),
          ),
          child: buttonContent,
        ),
      ),
    );
  }
}
