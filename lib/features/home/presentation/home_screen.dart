import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/restaurant_provider.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../shared/widgets/search_bar.dart';
import '../../../../shared/widgets/shimmer_loader.dart';
import 'widgets/restaurant_card.dart';
import 'widgets/category_chip.dart';

/// Premium home screen with animated header and featured restaurants carousel 
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load featured restaurants
    ref.read(restaurantProvider.notifier).loadFeaturedRestaurants();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _isScrolled = _scrollController.offset > 50;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final restaurantState = ref.watch(restaurantProvider);
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Animated App Bar
      SliverAppBar(
        expandedHeight: 200,
        floating: false,
        pinned: true,
        elevation: 0,
        backgroundColor: _isScrolled
            ? theme.scaffoldBackgroundColor
            : Colors.transparent,
        flexibleSpace: FlexibleSpaceBar(
          title: AnimatedOpacity(
            duration: AppConstants.defaultAnimationDuration,
            opacity: _isScrolled ? 1.0 : 0.0,
            child: Text(
              AppStrings.appName,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingXl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppConstants.spacingMd),
                    Text(
                      authState.isAuthenticated
                          ? 'Welcome back!'
                          : AppStrings.welcomeBack,
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn(
                      duration: AppConstants.defaultAnimationDuration,
                    ),
                    const SizedBox(height: AppConstants.spacingXs),
                    Text(
                      authState.isAuthenticated
                          ? 'Discover amazing restaurants'
                          : AppStrings.discover,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ).animate().fadeIn(
                      duration: AppConstants.defaultAnimationDuration,
                      delay: const Duration(milliseconds: 100),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(PhosphorIcons.bell(PhosphorIconsStyle.bold)),
            onPressed: () {
              // TODO: Implement notifications
            },
          ).animate().fadeIn(
            duration: AppConstants.defaultAnimationDuration,
            delay: const Duration(milliseconds: 200),
          ),
        ],
      ),

      // Search Bar
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
            vertical: AppConstants.spacingMd,
          ),
          child: CustomSearchBar(
            hintText: 'Search restaurants...',
            onChanged: (value) {
              if (value.isNotEmpty) {
                ref.read(restaurantProvider.notifier).searchRestaurants(value);
              } else {
                ref.read(restaurantProvider.notifier).loadFeaturedRestaurants();
              }
            },
          ).animate().slideY(
            duration: AppConstants.defaultAnimationDuration,
            delay: const Duration(milliseconds: 100),
            begin: -0.2,
            end: 0,
          ),
        ),
      ),

      // Featured Restaurants Section
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
            vertical: AppConstants.spacingMd,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.featuredRestaurants,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all restaurants
                },
                child: Text(
                  AppStrings.seeAll,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Featured Restaurants Carousel
      SliverToBoxAdapter(
        child: SizedBox(
          height: 280,
          child: restaurantState.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : restaurantState.restaurants.isEmpty
                  ? Center(
                      child: Text(
                        AppStrings.noRestaurantsFound,
                        style: theme.textTheme.bodyMedium,
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingLg,
                      ),
                      itemCount: restaurantState.restaurants.length,
                      itemBuilder: (context, index) {
                        final restaurant = restaurantState.restaurants[index];
                        return RestaurantCard(
                          restaurant: restaurant,
                          onTap: () {
                            // TODO: Navigate to restaurant details
                          },
                        ).animate().fadeIn(
                          duration: AppConstants.defaultAnimationDuration,
                          delay: Duration(milliseconds: 100 + (index * 50)),
                        );
                      },
                    ),
        ),
      ),

      const SliverToBoxAdapter(
        child: SizedBox(height: AppConstants.spacingLg),
      ),

      // Categories Section
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
            vertical: AppConstants.spacingMd,
          ),
          child: Text(
            AppStrings.categories,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      // Categories Horizontal List
      SliverToBoxAdapter(
        child: SizedBox(
          height: 60,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingLg,
            ),
            children: [
              CategoryChip(
                label: AppStrings.all,
                icon: PhosphorIcons.gridFour(PhosphorIconsStyle.bold),
                isSelected: true,
                onTap: () {},
              ),
              CategoryChip(
                label: AppStrings.starters,
                icon: PhosphorIcons.bowlFood(PhosphorIconsStyle.bold),
                onTap: () {},
              ),
              CategoryChip(
                label: AppStrings.mainCourse,
                icon: PhosphorIcons.forkKnife(PhosphorIconsStyle.bold),
                onTap: () {},
              ),
              CategoryChip(
                label: AppStrings.desserts,
                icon: PhosphorIcons.cake(PhosphorIconsStyle.bold),
                onTap: () {},
              ),
              CategoryChip(
                label: AppStrings.beverages,
                icon: PhosphorIcons.coffee(PhosphorIconsStyle.bold),
                onTap: () {},
              ),
              CategoryChip(
                label: AppStrings.snacks,
                icon: PhosphorIcons.cookie(PhosphorIconsStyle.bold),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),

      const SliverToBoxAdapter(
        child: SizedBox(height: AppConstants.spacingLg),
      ),

      // Near You Section
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
            vertical: AppConstants.spacingMd,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.nearYou,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all restaurants
                },
                child: Text(
                  AppStrings.seeAll,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Near You List
      SliverPadding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingLg,
        ),
        sliver: restaurantState.isLoading
            ? SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const ShimmerCard(
                    showImage: true,
                    showTitle: true,
                    showSubtitle: true,
                    subtitleLines: 2,
                  ),
                  childCount: 3,
                ),
              )
            : restaurantState.restaurants.isEmpty
                ? const SliverToBoxAdapter(
                    child: Center(
                      child: Text('No restaurants found'),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final restaurant = restaurantState.restaurants[index];
                        return RestaurantCard(
                          restaurant: restaurant,
                          isHorizontal: false,
                          onTap: () {
                            // TODO: Navigate to restaurant details
                          },
                        ).animate().fadeIn(
                          duration: AppConstants.defaultAnimationDuration,
                          delay: Duration(milliseconds: 100 + (index * 50)),
                        );
                      },
                      childCount: restaurantState.restaurants.length,
                    ),
                  ),
      ),

      const SliverToBoxAdapter(
        child: SizedBox(height: AppConstants.spacingXxl),
      ),
    ],
      ),
    );
  }
}
