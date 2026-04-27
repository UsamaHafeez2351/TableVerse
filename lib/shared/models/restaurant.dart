import 'menu_item.dart';

/// Restaurant entity with all necessary properties
class Restaurant {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String coverImageUrl;
  final String address;
  final String phone;
  final String email;
  final double rating;
  final int reviewCount;
  final String cuisineType;
  final String priceRange;
  final bool isOpen;
  final String openingHours;
  final double latitude;
  final double longitude;
  final List<String> categories;
  final List<MenuItem> menuItems;
  final DateTime createdAt;
  final DateTime updatedAt;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.coverImageUrl,
    required this.address,
    required this.phone,
    required this.email,
    required this.rating,
    required this.reviewCount,
    required this.cuisineType,
    required this.priceRange,
    required this.isOpen,
    required this.openingHours,
    required this.latitude,
    required this.longitude,
    required this.categories,
    this.menuItems = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'coverImageUrl': coverImageUrl,
      'address': address,
      'phone': phone,
      'email': email,
      'rating': rating,
      'reviewCount': reviewCount,
      'cuisineType': cuisineType,
      'priceRange': priceRange,
      'isOpen': isOpen,
      'openingHours': openingHours,
      'latitude': latitude,
      'longitude': longitude,
      'categories': categories,
      'menuItems': menuItems.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      coverImageUrl: json['coverImageUrl'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      cuisineType: json['cuisineType'] as String,
      priceRange: json['priceRange'] as String,
      isOpen: json['isOpen'] as bool,
      openingHours: json['openingHours'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      categories: List<String>.from(json['categories'] as List),
      menuItems: (json['menuItems'] as List<dynamic>?)
              ?.map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
