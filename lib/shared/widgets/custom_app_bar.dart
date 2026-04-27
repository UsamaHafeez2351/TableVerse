import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Premium custom app bar with glassmorphism effect
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool isTransparent;
  final Widget? flexibleSpace;

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.isTransparent = false,
    this.flexibleSpace,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor = isTransparent 
        ? Colors.transparent 
        : (backgroundColor ?? theme.appBarTheme.backgroundColor);
    final effectiveForegroundColor = foregroundColor ?? theme.appBarTheme.foregroundColor;

    return AppBar(
      title: title != null 
          ? Text(
              title!,
              style: theme.appBarTheme.titleTextStyle?.copyWith(
                color: effectiveForegroundColor,
              ),
            )
          : null,
      centerTitle: centerTitle,
      leading: leading ?? (showBackButton 
          ? IconButton(
              icon: Icon(
                PhosphorIcons.arrowLeft(PhosphorIconsStyle.bold),
                color: effectiveForegroundColor,
              ),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null),
      actions: actions,
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      elevation: elevation ?? theme.appBarTheme.elevation,
      scrolledUnderElevation: isTransparent ? 0 : theme.appBarTheme.scrolledUnderElevation,
      flexibleSpace: flexibleSpace,
      iconTheme: IconThemeData(color: effectiveForegroundColor),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Premium sliver app bar with parallax effect
class CustomSliverAppBar extends StatelessWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget? flexibleSpace;
  final bool pinned;
  final bool floating;
  final bool snap;
  final double? expandedHeight;
  final double? collapsedHeight;

  const CustomSliverAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.showBackButton = true,
    this.onBackPressed,
    this.flexibleSpace,
    this.pinned = true,
    this.floating = false,
    this.snap = false,
    this.expandedHeight,
    this.collapsedHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      title: title != null 
          ? Text(
              title!,
              style: theme.appBarTheme.titleTextStyle,
            )
          : null,
      centerTitle: centerTitle,
      leading: leading ?? (showBackButton 
          ? IconButton(
              icon: Icon(
                PhosphorIcons.arrowLeft(PhosphorIconsStyle.bold),
                color: theme.appBarTheme.foregroundColor,
              ),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null),
      actions: actions,
      backgroundColor: Colors.transparent,
      foregroundColor: theme.appBarTheme.foregroundColor,
      elevation: 0,
      expandedHeight: expandedHeight ?? 200,
      collapsedHeight: collapsedHeight,
      pinned: pinned,
      floating: floating,
      snap: snap,
      flexibleSpace: flexibleSpace,
    );
  }
}
