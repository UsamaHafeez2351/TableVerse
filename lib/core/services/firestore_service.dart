import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_constants.dart';
import '../../shared/models/restaurant.dart';
import '../../shared/models/menu_item.dart';
import '../../shared/models/category.dart';

/// Firestore service for database operations
class FirestoreService {
  FirestoreService._();

  static final FirestoreService _instance = FirestoreService._();
  static FirestoreService get instance => _instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== Restaurant Operations ====================
  
  /// Get all restaurants
  Future<List<Restaurant>> getAllRestaurants() async {
    try {
      final snapshot = await _firestore
          .collection('restaurants')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            if (data == null) throw Exception('Document data is null');
            return Restaurant.fromJson(data);
          })
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch restaurants');
    }
  }

  /// Get featured restaurants
  Future<List<Restaurant>> getFeaturedRestaurants() async {
    try {
      final snapshot = await _firestore
          .collection('restaurants')
          .where('rating', isGreaterThanOrEqualTo: 4.0)
          .orderBy('rating', descending: true)
          .limit(10)
          .get();

      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            if (data == null) throw Exception('Document data is null');
            return Restaurant.fromJson(data);
          })
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch featured restaurants');
    }
  }

  /// Get restaurant by ID
  Future<Restaurant?> getRestaurantById(String restaurantId) async {
    try {
      final doc = await _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .get();

      if (!doc.exists) return null;

      final data = doc.data();
      if (data == null) return null;
      return Restaurant.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch restaurant');
    }
  }

  /// Create restaurant
  Future<void> createRestaurant(Restaurant restaurant) async {
    try {
      await _firestore
          .collection('restaurants')
          .doc(restaurant.id)
          .set(restaurant.toJson());
    } catch (e) {
      throw Exception('Failed to create restaurant');
    }
  }

  /// Update restaurant
  Future<void> updateRestaurant(Restaurant restaurant) async {
    try {
      await _firestore
          .collection('restaurants')
          .doc(restaurant.id)
          .update(restaurant.toJson()..['updatedAt'] = DateTime.now().toIso8601String());
    } catch (e) {
      throw Exception('Failed to update restaurant');
    }
  }

  /// Delete restaurant
  Future<void> deleteRestaurant(String restaurantId) async {
    try {
      await _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete restaurant');
    }
  }

  // ==================== Menu Item Operations ====================

  /// Get menu items for a restaurant
  Future<List<MenuItem>> getMenuItems(String restaurantId) async {
    try {
      final snapshot = await _firestore
          .collection('menu_items')
          .where('restaurantId', isEqualTo: restaurantId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            if (data == null) throw Exception('Document data is null');
            return MenuItem.fromJson(data);
          })
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch menu items');
    }
  }

  /// Get menu items by category
  Future<List<MenuItem>> getMenuItemsByCategory(
    String restaurantId,
    String category,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('menu_items')
          .where('restaurantId', isEqualTo: restaurantId)
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            if (data == null) throw Exception('Document data is null');
            return MenuItem.fromJson(data);
          })
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch menu items');
    }
  }

  /// Get menu item by ID
  Future<MenuItem?> getMenuItemById(String itemId) async {
    try {
      final doc = await _firestore.collection('menu_items').doc(itemId).get();
      if (!doc.exists) return null;
      final data = doc.data();
      if (data == null) return null;
      return MenuItem.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch menu item');
    }
  }

  /// Create menu item
  Future<void> createMenuItem(MenuItem menuItem) async {
    try {
      await _firestore
          .collection('menu_items')
          .doc(menuItem.id)
          .set(menuItem.toJson());
    } catch (e) {
      throw Exception('Failed to create menu item');
    }
  }

  /// Update menu item
  Future<void> updateMenuItem(MenuItem menuItem) async {
    try {
      await _firestore
          .collection('menu_items')
          .doc(menuItem.id)
          .update(menuItem.toJson()..['updatedAt'] = DateTime.now().toIso8601String());
    } catch (e) {
      throw Exception('Failed to update menu item');
    }
  }

  /// Delete menu item
  Future<void> deleteMenuItem(String itemId) async {
    try {
      await _firestore
          .collection('menu_items')
          .doc(itemId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete menu item');
    }
  }

  // ==================== Search Operations ====================

  /// Search restaurants by name or cuisine
  Future<List<Restaurant>> searchRestaurants(String query) async {
    try {
      final snapshot = await _firestore
          .collection('restaurants')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .limit(AppConstants.defaultPageSize)
          .get();

      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            if (data == null) throw Exception('Document data is null');
            return Restaurant.fromJson(data);
          })
          .toList();
    } catch (e) {
      throw Exception('Failed to search restaurants');
    }
  }

  /// Search menu items
  Future<List<MenuItem>> searchMenuItems(
    String restaurantId,
    String query,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('menu_items')
          .where('restaurantId', isEqualTo: restaurantId)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .limit(AppConstants.defaultPageSize)
          .get();

      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            if (data == null) throw Exception('Document data is null');
            return MenuItem.fromJson(data);
          })
          .toList();
    } catch (e) {
      throw Exception('Failed to search menu items');
    }
  }
}
