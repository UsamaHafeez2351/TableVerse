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

/// Premium forgot password screen with animations
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.mediumImpact();
      await ref.read(authProvider.notifier).sendPasswordResetEmail(
        _emailController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Password reset email sent!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Reset Password',
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
                const SizedBox(height: AppConstants.spacingXl),

                // Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.infoLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    PhosphorIcons.lockKeyOpen(PhosphorIconsStyle.bold),
                    size: 48,
                    color: AppColors.info,
                  ),
                ).animate().scale(
                  duration: AppConstants.defaultAnimationDuration,
                  curve: AppConstants.smoothCurve,
                ),

                const SizedBox(height: AppConstants.spacingLg),

                // Title
                Text(
                  'Forgot Password?',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(
                  duration: AppConstants.defaultAnimationDuration,
                  delay: const Duration(milliseconds: 100),
                ),
                const SizedBox(height: AppConstants.spacingSm),
                Text(
                  'Enter your email address and we\'ll send you a link to reset your password.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(
                  duration: AppConstants.defaultAnimationDuration,
                  delay: const Duration(milliseconds: 200),
                ),

                const SizedBox(height: AppConstants.spacingXl),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
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
                  onFieldSubmitted: (_) => _handleResetPassword(),
                ).animate().slideX(
                  duration: AppConstants.defaultAnimationDuration,
                  delay: const Duration(milliseconds: 300),
                  begin: -0.2,
                  end: 0,
                ),

                const SizedBox(height: AppConstants.spacingXl),

                // Reset Button
                PrimaryButton(
                  text: 'Send Reset Link',
                  onPressed: _handleResetPassword,
                  isLoading: authState.isLoading,
                ).animate().slideY(
                  duration: AppConstants.defaultAnimationDuration,
                  delay: const Duration(milliseconds: 400),
                  begin: 0.2,
                  end: 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
