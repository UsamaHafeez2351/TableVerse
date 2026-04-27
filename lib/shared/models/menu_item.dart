/// Menu item entity with AR support
class MenuItem {
  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final String? modelUrl; // 3D model URL for AR
  final double? size; // Size in cm for realistic AR scaling
  final List<String> tags;
  final bool isAvailable;
  final int popularity;
  final DateTime createdAt;
  final DateTime updatedAt;

  MenuItem({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.modelUrl,
    this.size,
    this.tags = const [],
    this.isAvailable = true,
    this.popularity = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Check if item has 3D model for AR
  bool get has3DModel => modelUrl != null && modelUrl!.isNotEmpty;

  /// Get formatted price with currency
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'modelUrl': modelUrl,
      'size': size,
      'tags': tags,
      'isAvailable': isAvailable,
      'popularity': popularity,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      restaurantId: json['restaurantId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String,
      modelUrl: json['modelUrl'] as String?,
      size: json['size'] as double?,
      tags: List<String>.from(json['tags'] as List? ?? []),
      isAvailable: json['isAvailable'] as bool? ?? true,
      popularity: json['popularity'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
