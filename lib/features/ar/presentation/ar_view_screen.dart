import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/models/menu_item.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/glass_card.dart';

/// Premium AR preview screen for viewing menu items in 3D / immersive mode
class ARViewScreen extends ConsumerStatefulWidget {
  final MenuItem menuItem;

  const ARViewScreen({
    super.key,
    required this.menuItem,
  });

  @override
  ConsumerState<ARViewScreen> createState() => _ARViewState();
}

class _ARViewState extends ConsumerState<ARViewScreen> {
  bool _isLoading = false;
  bool _show3D = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(AppStrings.arMode),
        actions: [
          IconButton(
            icon: Icon(PhosphorIcons.arrowsClockwise(PhosphorIconsStyle.bold)),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              Future.delayed(const Duration(milliseconds: 300), () {
                setState(() {
                  _isLoading = false;
                });
              });
            },
            tooltip: AppStrings.reset,
          ),
        ],
      ),
      body: Stack(
        children: [
          // 3D Model or 2D Image Viewer
          _buildViewer(theme),

          // Loading Indicator
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
            ),

          // Controls Overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              padding: const EdgeInsets.all(AppConstants.spacingLg),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Toggle 3D / 2D
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildToggleButton(
                          '3D View',
                          PhosphorIcons.cube(PhosphorIconsStyle.bold),
                          _show3D,
                          () => setState(() => _show3D = true),
                        ),
                        const SizedBox(width: AppConstants.spacingMd),
                        _buildToggleButton(
                          '2D View',
                          PhosphorIcons.image(PhosphorIconsStyle.bold),
                          !_show3D,
                          () => setState(() => _show3D = false),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Item Info Card
                    GlassCard(
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusSm,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: widget.menuItem.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: AppConstants.spacingMd),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.menuItem.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  widget.menuItem.formattedPrice,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PrimaryButton(
                            text: AppStrings.addToCart,
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              // TODO: Add to cart
                            },
                            icon: PhosphorIcons.plusCircle(PhosphorIconsStyle.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewer(ThemeData theme) {
    if (_show3D && widget.menuItem.has3DModel) {
      return _build3DModelViewer();
    }
    return _build2DImageViewer(theme);
  }

  Widget _build3DModelViewer() {
    return Container(
      color: Colors.black,
      child: Center(
        child: ModelViewer(
          src: widget.menuItem.modelUrl!,
          alt: widget.menuItem.name,
          autoRotate: true,
          cameraControls: true,
          backgroundColor: const Color(0x00000000),
        ),
      ),
    );
  }

  Widget _build2DImageViewer(ThemeData theme) {
    return Container(
      color: Colors.black,
      child: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: CachedNetworkImage(
            imageUrl: widget.menuItem.imageUrl,
            fit: BoxFit.contain,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
            errorWidget: (context, url, error) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  PhosphorIcons.imageBroken(PhosphorIconsStyle.bold),
                  size: 64,
                  color: Colors.white54,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                Text(
                  'Failed to load image',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(
    String label,
    IconData icon,
    bool isActive,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? AppColors.primary : Colors.white24,
        foregroundColor: isActive ? Colors.white : Colors.white70,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd,
          vertical: AppConstants.spacingSm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
        ),
      ),
    );
  }
}
