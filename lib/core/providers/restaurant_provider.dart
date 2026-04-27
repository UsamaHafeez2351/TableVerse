import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firestore_service.dart';
import '../../shared/models/restaurant.dart';
import '../../shared/models/menu_item.dart';

/// Firestore service provider
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService.instance;
});

/// Restaurant state
class RestaurantState {
  final bool isLoading;
  final List<Restaurant> restaurants;
  final String? errorMessage;

  const RestaurantState({
    this.isLoading = false,
    this.restaurants = const [],
    this.errorMessage,
  });

  RestaurantState copyWith({
    bool? isLoading,
    List<Restaurant>? restaurants,
    String? errorMessage,
  }) {
    return RestaurantState(
      isLoading: isLoading ?? this.isLoading,
      restaurants: restaurants ?? this.restaurants,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Restaurant notifier
class RestaurantNotifier extends StateNotifier<RestaurantState> {
  final FirestoreService _firestoreService;

  RestaurantNotifier(this._firestoreService) : super(const RestaurantState());

  Future<void> loadRestaurants() async {
    state = state.copyWith(isLoading: true);
    try {
      final restaurants = await _firestoreService.getAllRestaurants();
      state = state.copyWith(
        isLoading: false,
        restaurants: restaurants,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> loadFeaturedRestaurants() async {
    state = state.copyWith(isLoading: true);
    try {
      final restaurants = await _firestoreService.getFeaturedRestaurants();
      state = state.copyWith(
        isLoading: false,
        restaurants: restaurants,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<Restaurant?> getRestaurantById(String restaurantId) async {
    try {
      return await _firestoreService.getRestaurantById(restaurantId);
    } catch (e) {
      return null;
    }
  }

  Future<void> searchRestaurants(String query) async {
    state = state.copyWith(isLoading: true);
    try {
      final restaurants = await _firestoreService.searchRestaurants(query);
      state = state.copyWith(
        isLoading: false,
        restaurants: restaurants,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

/// Restaurant provider
final restaurantProvider =
    StateNotifierProvider<RestaurantNotifier, RestaurantState>((ref) {
  return RestaurantNotifier(ref.watch(firestoreServiceProvider));
});

/// Featured restaurants provider
final featuredRestaurantsProvider =
    FutureProvider.autoDispose<List<Restaurant>>((ref) async {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return await firestoreService.getFeaturedRestaurants();
});

/// Single restaurant provider
final restaurantByIdProvider =
    FutureProvider.family<Restaurant?, String>((ref, restaurantId) async {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return await firestoreService.getRestaurantById(restaurantId);
});

/// Menu items provider
final menuItemsProvider =
    FutureProvider.family<List<MenuItem>, String>((ref, restaurantId) async {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return await firestoreService.getMenuItems(restaurantId);
});

/// Menu items by category provider
final menuItemsByCategoryProvider = FutureProvider.family<
    List<MenuItem>,
    ({String restaurantId, String category})>((ref, params) async {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return await firestoreService.getMenuItemsByCategory(
    params.restaurantId,
    params.category,
  );
});
