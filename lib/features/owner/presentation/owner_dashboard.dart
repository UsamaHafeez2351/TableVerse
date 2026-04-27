import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/primary_button.dart';
import 'add_edit_item_screen.dart';

/// Premium restaurant owner dashboard
class OwnerDashboard extends ConsumerStatefulWidget {
  const OwnerDashboard({super.key});

  @override
  ConsumerState<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends ConsumerState<OwnerDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardHomeScreen(),
    const MenuManagementScreen(),
    const AnalyticsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: AppConstants.borderRadiusLg,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingMd,
              vertical: AppConstants.spacingXs,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: PhosphorIcons.house(PhosphorIconsStyle.bold),
                  label: 'Home',
                  index: 0,
                ),
                _buildNavItem(
                  icon: PhosphorIcons.bookOpen(PhosphorIconsStyle.bold),
                  label: 'Menu',
                  index: 1,
                ),
                _buildNavItem(
                  icon: PhosphorIcons.chartLineUp(PhosphorIconsStyle.bold),
                  label: 'Analytics',
                  index: 2,
                ),
                _buildNavItem(
                  icon: PhosphorIcons.gear(PhosphorIconsStyle.bold),
                  label: 'Settings',
                  index: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final theme = Theme.of(context);
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: AppConstants.defaultAnimationDuration,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd,
          vertical: AppConstants.spacingSm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : theme.iconTheme.color,
              size: isSelected ? AppConstants.iconSizeLg : AppConstants.iconSizeMd,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isSelected ? AppColors.primary : theme.textTheme.bodySmall?.color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dashboard home screen with stats
class DashboardHomeScreen extends ConsumerWidget {
  const DashboardHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dashboard),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            GlassCard(
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: AppColors.primaryGradient,
                      ),
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusMd,
                      ),
                    ),
                    child: Icon(
                      PhosphorIcons.storefront(PhosphorIconsStyle.bold),
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back!',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          authState.user?.email ?? '',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideX(),

            const SizedBox(height: AppConstants.spacingLg),

            // Stats Grid
            Text(
              'Overview',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(delay: const Duration(milliseconds: 100)),
            const SizedBox(height: AppConstants.spacingMd),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: AppConstants.spacingMd,
              crossAxisSpacing: AppConstants.spacingMd,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard(
                  context,
                  icon: PhosphorIcons.bowlFood(PhosphorIconsStyle.bold),
                  title: 'Menu Items',
                  value: '24',
                  color: AppColors.primary,
                ).animate().fadeIn(delay: const Duration(milliseconds: 200)),
                _buildStatCard(
                  context,
                  icon: PhosphorIcons.users(PhosphorIconsStyle.bold),
                  title: 'Orders',
                  value: '156',
                  color: AppColors.secondary,
                ).animate().fadeIn(delay: const Duration(milliseconds: 300)),
                _buildStatCard(
                  context,
                  icon: PhosphorIcons.star(PhosphorIconsStyle.bold),
                  title: 'Rating',
                  value: '4.8',
                  color: AppColors.warning,
                ).animate().fadeIn(delay: const Duration(milliseconds: 400)),
                _buildStatCard(
                  context,
                  icon: PhosphorIcons.currencyDollar(PhosphorIconsStyle.bold),
                  title: 'Revenue',
                  value: '\$2.4k',
                  color: AppColors.success,
                ).animate().fadeIn(delay: const Duration(milliseconds: 500)),
              ],
            ),

            const SizedBox(height: AppConstants.spacingXl),

            // Quick Actions
            Text(
              'Quick Actions',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(delay: const Duration(milliseconds: 600)),
            const SizedBox(height: AppConstants.spacingMd),

            _buildQuickAction(
              context,
              icon: PhosphorIcons.plus(PhosphorIconsStyle.bold),
              title: 'Add New Item',
              subtitle: 'Add a new menu item',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AddEditItemScreen(),
                  ),
                );
              },
            ).animate().fadeIn(delay: const Duration(milliseconds: 700)),
            const SizedBox(height: AppConstants.spacingMd),
            _buildQuickAction(
              context,
              icon: PhosphorIcons.pencilSimple(PhosphorIconsStyle.bold),
              title: 'Edit Restaurant',
              subtitle: 'Update restaurant details',
              onTap: () {
                // TODO: Navigate to edit restaurant
              },
            ).animate().fadeIn(delay: const Duration(milliseconds: 800)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return GlassCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GlassCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Icon(
            PhosphorIcons.caretRight(PhosphorIconsStyle.bold),
            color: theme.iconTheme.color,
          ),
        ],
      ),
    );
  }
}

/// Menu management screen
class MenuManagementScreen extends ConsumerWidget {
  const MenuManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.manageMenu),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(PhosphorIcons.plus(PhosphorIconsStyle.bold)),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AddEditItemScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIcons.bookOpen(PhosphorIconsStyle.bold),
              size: 64,
              color: theme.textTheme.bodySmall?.color,
            ),
            const SizedBox(height: AppConstants.spacingMd),
            Text(
              'Menu Management',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              'Your menu items will appear here',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

/// Analytics screen placeholder
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIcons.chartLineUp(PhosphorIconsStyle.bold),
              size: 64,
              color: theme.textTheme.bodySmall?.color,
            ),
            const SizedBox(height: AppConstants.spacingMd),
            Text(
              'Analytics',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              'Analytics coming soon',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

/// Settings screen placeholder
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        children: [
          _buildSettingItem(
            context,
            icon: PhosphorIcons.user(PhosphorIconsStyle.bold),
            title: 'Profile',
            subtitle: 'Update your profile',
            onTap: () {},
          ),
          _buildSettingItem(
            context,
            icon: PhosphorIcons.bell(PhosphorIconsStyle.bold),
            title: 'Notifications',
            subtitle: 'Manage notifications',
            onTap: () {},
          ),
          _buildSettingItem(
            context,
            icon: PhosphorIcons.shield(PhosphorIconsStyle.bold),
            title: 'Privacy',
            subtitle: 'Privacy settings',
            onTap: () {},
          ),
          _buildSettingItem(
            context,
            icon: PhosphorIcons.question(PhosphorIconsStyle.bold),
            title: 'Help & Support',
            subtitle: 'Get help',
            onTap: () {},
          ),
          const SizedBox(height: AppConstants.spacingLg),
          PrimaryButton(
            text: AppStrings.logout,
            onPressed: () {
              // TODO: Implement logout
            },
            isOutlined: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GlassCard(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Icon(
            PhosphorIcons.caretRight(PhosphorIconsStyle.bold),
            color: theme.iconTheme.color,
          ),
        ],
      ),
    );
  }
}
