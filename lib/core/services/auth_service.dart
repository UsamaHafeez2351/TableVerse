import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_strings.dart';
import '../../shared/models/user.dart';

/// Authentication service for Firebase Auth
class AuthService {
  AuthService._();

  static final AuthService _instance = AuthService._();
  static AuthService get instance => _instance;

  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream of auth state changes
  Stream<firebase_auth.User?> get authStateChanges => _auth.authStateChanges();

  /// Get current user
  firebase_auth.User? get currentUser => _auth.currentUser;

  /// Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Check if user is logged in
  bool get isLoggedIn => _auth.currentUser != null;

  /// Sign up with email and password
  Future<firebase_auth.User> signUp({
    required String email,
    required String password,
    required String name,
    bool isRestaurantOwner = false,
  }) async {
    try {
      // Create auth user
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user!;
      
      // Create user document in Firestore
      final userModel = User(
        id: user.uid,
        email: email,
        name: name,
        isRestaurantOwner: isRestaurantOwner,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toJson());

      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _getAuthErrorMessage(e);
    }
  }

  /// Sign in with email and password
  Future<firebase_auth.User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user!;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _getAuthErrorMessage(e);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception(AppStrings.somethingWentWrong);
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _getAuthErrorMessage(e);
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    String? name,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception(AppStrings.somethingWentWrong);

      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
      if (avatarUrl != null) updates['avatarUrl'] = avatarUrl;
      updates['updatedAt'] = DateTime.now().toIso8601String();

      await _firestore
          .collection('users')
          .doc(user.uid)
          .update(updates);
    } catch (e) {
      throw Exception(AppStrings.somethingWentWrong);
    }
  }

  /// Get user data from Firestore
  Future<User?> getUserData(String userId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      if (!doc.exists) return null;

      return User.fromJson(doc.data()!);
    } catch (e) {
      throw Exception(AppStrings.somethingWentWrong);
    }
  }

  /// Delete user account
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception(AppStrings.somethingWentWrong);

      // Delete user document
      await _firestore
          .collection('users')
          .doc(user.uid)
          .delete();

      // Delete auth user
      await user.delete();
    } catch (e) {
      throw Exception(AppStrings.somethingWentWrong);
    }
  }

  String _getAuthErrorMessage(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return AppStrings.weakPassword;
      case 'email-already-in-use':
        return 'An account with this email already exists';
      case 'invalid-email':
        return AppStrings.invalidEmail;
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      default:
        return AppStrings.somethingWentWrong;
    }
  }
}
