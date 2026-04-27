import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';

/// Firebase service initialization and configuration
class FirebaseService {
  FirebaseService._();

  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._();

  bool _isInitialized = false;

  /// Initialize Firebase
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize Firebase: $e');
    }
  }

  /// Check if Firebase is initialized
  bool get isInitialized => _isInitialized;
}
