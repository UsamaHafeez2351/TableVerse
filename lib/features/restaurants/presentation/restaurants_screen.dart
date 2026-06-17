import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/restaurant_provider.dart';
import '../../../../shared/widgets/search_bar.dart';
import '../../../../shared/widgets/shimmer_loader.dart';
import '../../home/presentation/widgets/restaurant_card.dart';

/// Premium restaurants listing screen with filters and search 
class RestaurantsScreen extends ConsumerStatefulWidget {
  const RestaurantsScreen({super.key});

  @override
  ConsumerState<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends ConsumerState<RestaurantsScreen> {
  final ScrollController _scrollController = ScrollController();
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    ref.read(restaurantProvider.notifier).loadRestaurants();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Implement infinite scroll pagination
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final restaurantState = ref.watch(restaurantProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.restaurants),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            child: CustomSearchBar(
              hintText: 'Search restaurants...',
              onChanged: (value) {
                if (value.isNotEmpty) {
                  ref.read(restaurantProvider.notifier).searchRestaurants(value);
                } else {
                  ref.read(restaurantProvider.notifier).loadRestaurants();
                }
              },
            ),
          ),

          // Category Filters
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingLg,
              ),
              children: [
                _buildCategoryChip(
                  'All',
                  PhosphorIcons.gridFour(PhosphorIconsStyle.bold),
                  _selectedCategory == 'All',
                  () {
                    setState(() {
                      _selectedCategory = 'All';
                    });
                    ref.read(restaurantProvider.notifier).loadRestaurants();
                  },
                ),
                _buildCategoryChip(
                  'Italian',
                  PhosphorIcons.pizza(PhosphorIconsStyle.bold),
                  _selectedCategory == 'Italian',
                  () {
                    setState(() {
                      _selectedCategory = 'Italian';
                    });
                  },
                ),
                _buildCategoryChip(
                  'Asian',
                  PhosphorIcons.bowlFood(PhosphorIconsStyle.bold),
                  _selectedCategory == 'Asian',
                  () {
                    setState(() {
                      _selectedCategory = 'Asian';
                    });
                  },
                ),
                _buildCategoryChip(
                  'Mexican',
                  PhosphorIcons.pizza(PhosphorIconsStyle.bold),
                  _selectedCategory == 'Mexican',
                  () {
                    setState(() {
                      _selectedCategory = 'Mexican';
                    });
                  },
                ),
                _buildCategoryChip(
                  'American',
                  PhosphorIcons.hamburger(PhosphorIconsStyle.bold),
                  _selectedCategory == 'American',
                  () {
                    setState(() {
                      _selectedCategory = 'American';
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: AppConstants.spacingMd),

          // Restaurant List
          Expanded(
            child: restaurantState.isLoading
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingLg,
                    ),
                    itemCount: 5,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppConstants.spacingMd,
                      ),
                      child: const ShimmerCard(
                        showImage: true,
                        showTitle: true,
                        showSubtitle: true,
                        subtitleLines: 2,
                      ),
                    ),
                  )
                : restaurantState.restaurants.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              PhosphorIcons.storefront(PhosphorIconsStyle.bold),
                              size: 64,
                              color: theme.textTheme.bodySmall?.color,
                            ),
                            const SizedBox(height: AppConstants.spacingMd),
                            Text(
                              AppStrings.noRestaurantsFound,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingLg,
                        ),
                        itemCount: restaurantState.restaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant = restaurantState.restaurants[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppConstants.spacingMd,
                            ),
                            child: RestaurantCard(
                              restaurant: restaurant,
                              isHorizontal: false,
                              onTap: () {
                                // TODO: Navigate to restaurant details
                              },
                            ).animate().fadeIn(
                              duration: AppConstants.defaultAnimationDuration,
                              delay: Duration(milliseconds: 50 * index),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.defaultAnimationDuration,
        margin: const EdgeInsets.only(right: AppConstants.spacingSm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd,
          vertical: AppConstants.spacingSm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusXl),
          border: Border.all(
            color: isSelected ? AppColors.primary : Theme.of(context).colorScheme.outline,
          ),
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
