import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/restaurant_provider.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/shimmer_loader.dart';
import '../../../../shared/models/menu_item.dart';

/// Premium menu screen with categorized tabs and item cards
class MenuScreen extends ConsumerStatefulWidget {
  final String restaurantId;

  const MenuScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Starters',
    'Main Course',
    'Desserts',
    'Beverages',
    'Snacks',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _categories.length,
      vsync: this,
    );
    _tabController.addListener(_onTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedCategory = _categories[_tabController.index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final menuItemsAsync = ref.watch(
      menuItemsByCategoryProvider((
        restaurantId: widget.restaurantId,
        category: _selectedCategory == 'All' ? '' : _selectedCategory,
      )),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Restaurant Info
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Menu',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primaryDark,
                    ],
                  ),
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: _categories
                  .map((category) => Tab(text: category))
                  .toList(),
            ),
          ),

          // Menu Items
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            sliver: menuItemsAsync.when(
              data: (menuItems) {
                if (menuItems.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Text('No items in this category'),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = menuItems[index];
                      return MenuItemCard(
                        menuItem: item,
                        onTap: () {
                          // TODO: Navigate to item details
                        },
                        onViewAR: () {
                          // TODO: Navigate to AR view
                        },
                      ).animate().fadeIn(
                        duration: AppConstants.defaultAnimationDuration,
                        delay: Duration(milliseconds: 50 * index),
                      );
                    },
                    childCount: menuItems.length,
                  ),
                );
              },
              loading: () => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppConstants.spacingMd,
                    ),
                    child: const ShimmerCard(
                      showImage: true,
                      showTitle: true,
                      showSubtitle: true,
                      showButton: true,
                      subtitleLines: 2,
                    ),
                  ),
                  childCount: 5,
                ),
              ),
              error: (error, stack) => SliverToBoxAdapter(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        PhosphorIcons.warningCircle(PhosphorIconsStyle.bold),
                        size: 64,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: AppConstants.spacingMd),
                      Text(
                        'Error loading menu',
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: AppConstants.spacingSm),
                      Text(
                        error.toString(),
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Premium menu item card
class MenuItemCard extends StatelessWidget {
  final MenuItem menuItem;
  final VoidCallback onTap;
  final VoidCallback onViewAR;

  const MenuItemCard({
    super.key,
    required this.menuItem,
    required this.onTap,
    required this.onViewAR,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
            child: CachedNetworkImage(
              imageUrl: menuItem.imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 100,
                height: 100,
                color: context.surfaceVariant,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 100,
                height: 100,
                color: context.surfaceVariant,
                child: Icon(
                  PhosphorIcons.image(PhosphorIconsStyle.bold),
                  size: 32,
                  color: context.textTertiary,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        menuItem.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (menuItem.has3DModel)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingXs,
                          vertical: AppConstants.spacingXxs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.infoLight,
                          borderRadius: BorderRadius.circular(
                            AppConstants.borderRadiusSm,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              PhosphorIcons.cube(PhosphorIconsStyle.bold),
                              size: 12,
                              color: AppColors.info,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '3D',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.info,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingXs),
                Text(
                  menuItem.description,
                  style: theme.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppConstants.spacingSm),
                Row(
                  children: [
                    Text(
                      menuItem.formattedPrice,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    // View in AR Button
                    if (menuItem.has3DModel)
                      IconButton(
                        icon: Icon(PhosphorIcons.cube(PhosphorIconsStyle.bold)),
                        onPressed: onViewAR,
                        tooltip: AppStrings.viewInAR,
                        color: AppColors.primary,
                      ),
                    // Add to Cart Button
                    IconButton(
                      icon: Icon(PhosphorIcons.plusCircle(PhosphorIconsStyle.bold)),
                      onPressed: () {
                        // TODO: Add to cart
                      },
                      tooltip: AppStrings.addToCart,
                      color: AppColors.secondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension MenuScreenExtension on BuildContext {
  Color get surfaceVariant => Theme.of(this).colorScheme.surfaceContainerHighest;
  Color get textTertiary => Theme.of(this).textTheme.bodySmall?.color ?? Colors.grey;
}
