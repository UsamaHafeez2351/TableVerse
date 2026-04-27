import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

/// Premium signup screen with animations
class SignupScreen extends ConsumerStatefulWidget {
  final bool isRestaurantOwner;

  const SignupScreen({
    super.key,
    this.isRestaurantOwner = false,
  });

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.mediumImpact();
      await ref.read(authProvider.notifier).signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        isRestaurantOwner: widget.isRestaurantOwner,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);

    // Navigate to home on successful signup
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else if (next.errorMessage != null && previous?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.signup,
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingXl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppConstants.spacingLg),

                // Title
                Text(
                  'Create your ${widget.isRestaurantOwner ? 'restaurant' : ''} account',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(
                  duration: AppConstants.defaultAnimationDuration,
                ),
                const SizedBox(height: AppConstants.spacingXs),
                Text(
                  'Start your journey with ${AppStrings.appName}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(
                  duration: AppConstants.defaultAnimationDuration,
                  delay: const Duration(milliseconds: 100),
                ),

                const SizedBox(height: AppConstants.spacingXl),

                // Name Field
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    prefixIcon: Icon(PhosphorIcons.user(PhosphorIconsStyle.bold)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ).animate().slideX(
                  duration: AppConstants.defaultAnimationDuration,
                  delay: const Duration(milliseconds: 200),
                  begin: -0.2,
                  end: 0,
                ),

                const SizedBox(height: AppConstants.spacingMd),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: AppStrings.email,
                    hintText: 'Enter your email',
                    prefixIcon: Icon(PhosphorIcons.envelope(PhosphorIconsStyle.bold)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.invalidEmail;
                    }
                    if (!value.contains('@')) {
                      return AppStrings.invalidEmail;
                    }
                    return null;
                  },
                ).animate().slideX(
                  duration: AppConstants.defaultAnimationDuration,
                  delay: const Duration(milliseconds: 300),
                  begin: -0.2,
                  end: 0,
                ),

                const SizedBox(height: AppConstants.spacingMd),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: AppStrings.password,
                    hintText: 'Create a password',
                    prefixIcon: Icon(PhosphorIcons.lock(PhosphorIconsStyle.bold)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? PhosphorIcons.eye(PhosphorIconsStyle.bold)
                            : PhosphorIcons.eyeSlash(PhosphorIconsStyle.bold),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                        HapticFeedback.lightImpact();
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return AppStrings.weakPassword;
                    }
                    return null;
                  },
                ).animate().slideX(
                  duration: AppConstants.defaultAnimationDuration,
                  delay: const Duration(milliseconds: 400),
                  begin: -0.2,
                  end: 0,
                ),

                const SizedBox(height: AppConstants.spacingMd),

                // Confirm Password Field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: AppStrings.confirmPassword,
                    hintText: 'Confirm your password',
                    prefixIcon: Icon(PhosphorIcons.lockKey(PhosphorIconsStyle.bold)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? PhosphorIcons.eye(PhosphorIconsStyle.bold)
                            : PhosphorIcons.eyeSlash(PhosphorIconsStyle.bold),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                        HapticFeedback.lightImpact();
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return AppStrings.passwordMismatch;
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _handleSignup(),
                ).animate().slideX(
                  duration: AppConstants.defaultAnimationDuration,
                  delay: const Duration(milliseconds: 500),
                  begin: -0.2,
                  end: 0,
                ),

                const SizedBox(height: AppConstants.spacingXl),

                // Signup Button
                PrimaryButton(
                  text: AppStrings.signup,
                  onPressed: _handleSignup,
                  isLoading: authState.isLoading,
                ).animate().slideY(
                  duration: AppConstants.defaultAnimationDuration,
                  delay: const Duration(milliseconds: 600),
                  begin: 0.2,
                  end: 0,
                ),

                const SizedBox(height: AppConstants.spacingLg),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.haveAccount,
                      style: theme.textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        AppStrings.login,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(
                  duration: AppConstants.defaultAnimationDuration,
                  delay: const Duration(milliseconds: 700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
