import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/services/firebase_service.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/auth_provider.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/restaurants/presentation/restaurants_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await FirebaseService.instance.initialize();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    const ProviderScope(
      child: TableVerseApp(),
    ),
  );
}

class TableVerseApp extends ConsumerWidget {
  const TableVerseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'TableVerse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode.brightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            final authState = ref.read(authProvider);
            
            // Check authentication
            if (settings.name == '/' && !authState.isAuthenticated) {
              return const LoginScreen();
            }
            
            switch (settings.name) {
              case '/':
                return authState.isAuthenticated
                    ? const HomeScreen()
                    : const LoginScreen();
              case '/home':
                return const HomeScreen();
              case '/restaurants':
                return const RestaurantsScreen();
              default:
                return const HomeScreen();
            }
          },
        );
      },
    );
  }
}
