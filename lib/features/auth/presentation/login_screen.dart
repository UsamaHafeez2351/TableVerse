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
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

/// Premium login screen with animations
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isRestaurantOwner = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.mediumImpact();
      await ref.read(authProvider.notifier).signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);

    // Navigate to home on successful login
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated && (previous?.isAuthenticated ?? false) == false) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingXl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppConstants.spacingXxl),
                
                // Logo and Title
                Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: AppColors.primaryGradient,
                        ),
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusXl),
                      ),
                      child: Icon(
                        PhosphorIcons.forkKnife(PhosphorIconsStyle.bold),
                        size: 40,
                        color: Colors.white,
                      ),
                    ).animate().scale(
                      duration: AppConstants.defaultAnimationDuration,
                      curve: AppConstants.smoothCurve,
                    ),
                    const SizedBox(height: AppConstants.spacingLg),
                    Text(
                      AppStrings.appName,
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ).animate().fadeIn(
                      duration: AppConstants.defaultAnimationDuration,
                      delay: const Duration(milliseconds: 100),
                    ),
                    const SizedBox(height: AppConstants.spacingXs),
                    Text(
                      AppStrings.appTagline,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                      ),
                    ).animate().fadeIn(
                      duration: AppConstants.defaultAnimationDuration,
                      delay: const Duration(milliseconds: 200),
                    ),
                  ],
                ),

                const SizedBox(height: AppConstants.spacingXxl),

                // User Type Toggle
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingXs),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusMd),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isRestaurantOwner = false;
                            });
                            HapticFeedback.lightImpact();
                          },
                          child: AnimatedContainer(
                            duration: AppConstants.fastAnimationDuration,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppConstants.spacingSm,
                            ),
                            decoration: BoxDecoration(
                              color: !_isRestaurantOwner
                                  ? AppColors.primary
                                  : Colors.transparent,
                              borderRadius:
                                  BorderRadius.circular(AppConstants.borderRadiusSm),
                            ),
                            child: Text(
                              AppStrings.user,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: !_isRestaurantOwner
                                    ? Colors.white
                                    : theme.textTheme.bodyMedium?.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isRestaurantOwner = true;
                            });
                            HapticFeedback.lightImpact();
                          },
                          child: AnimatedContainer(
                            duration: AppConstants.fastAnimationDuration,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppConstants.spacingSm,
                            ),
                            decoration: BoxDecoration(
                              color: _isRestaurantOwner
                                  ? AppColors.primary
                                  : Colors.transparent,
                              borderRadius:
                                  BorderRadius.circular(AppConstants.borderRadiusSm),
                            ),
                            child: Text(
                              AppStrings.restaurantOwner,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: _isRestaurantOwner
                                    ? Colors.white
                                    : theme.textTheme.bodyMedium?.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(
                  duration: AppConstants.defaultAnimationDuration,
                  delay: const Duration(milliseconds: 300),
                ),

                const SizedBox(height: AppConstants.spacingLg),

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
                  delay: const Duration(milliseconds: 400),
                  begin: -0.2,
                  end: 0,
                ),

                const SizedBox(height: AppConstants.spacingMd),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: AppStrings.password,
                    hintText: 'Enter your password',
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
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _handleLogin(),
                ).animate().slideX(
                  duration: AppConstants.defaultAnimationDuration,
                  delay: const Duration(milliseconds: 500),
                  begin: -0.2,
                  end: 0,
                ),

                const SizedBox(height: AppConstants.spacingXs),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: Text(
                      AppStrings.forgotPassword,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ).animate().fadeIn(
                  duration: AppConstants.defaultAnimationDuration,
                  delay: const Duration(milliseconds: 600),
                ),

                const SizedBox(height: AppConstants.spacingLg),

                // Login Button
                PrimaryButton(
                  text: AppStrings.login,
                  onPressed: _handleLogin,
                  isLoading: authState.isLoading,
                ).animate().slideY(
                  duration: AppConstants.defaultAnimationDuration,
                  delay: const Duration(milliseconds: 700),
                  begin: 0.2,
                  end: 0,
                ),

                const SizedBox(height: AppConstants.spacingLg),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.noAccount,
                      style: theme.textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SignupScreen(
                              isRestaurantOwner: _isRestaurantOwner,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        AppStrings.signup,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(
                  duration: AppConstants.defaultAnimationDuration,
                  delay: const Duration(milliseconds: 800),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
