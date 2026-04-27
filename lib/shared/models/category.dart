import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Category entity with color coding
class Category {
  final String id;
  final String name;
  final String icon;
  final Color color;
  final int itemCount;
  final int sortOrder;
  final DateTime? createdAt;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.itemCount,
    this.sortOrder = 0,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color.toARGB32(),
      'itemCount': itemCount,
      'sortOrder': sortOrder,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      color: Color(json['color'] as int),
      itemCount: json['itemCount'] as int,
      sortOrder: json['sortOrder'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }
}

/// Predefined categories for the app
class AppCategories {
  static Category all() => Category(
    id: 'all',
    name: 'All',
    icon: 'grid',
    color: AppColors.primary,
    itemCount: 0,
    createdAt: null,
  );

  static Category starters() => Category(
    id: 'starters',
    name: 'Starters',
    icon: 'bowl-food',
    color: AppColors.categoryStarters,
    itemCount: 0,
    createdAt: null,
  );

  static Category mainCourse() => Category(
    id: 'main_course',
    name: 'Main Course',
    icon: 'fork-knife',
    color: AppColors.categoryMainCourse,
    itemCount: 0,
    createdAt: null,
  );

  static Category desserts() => Category(
    id: 'desserts',
    name: 'Desserts',
    icon: 'cake',
    color: AppColors.categoryDesserts,
    itemCount: 0,
    createdAt: null,
  );

  static Category beverages() => Category(
    id: 'beverages',
    name: 'Beverages',
    icon: 'coffee',
    color: AppColors.categoryBeverages,
    itemCount: 0,
    createdAt: null,
  );

  static Category snacks() => Category(
    id: 'snacks',
    name: 'Snacks',
    icon: 'cookie',
    color: AppColors.categorySnacks,
    itemCount: 0,
    createdAt: null,
  );

  static List<Category> defaultCategories() => [
    all(),
    starters(),
    mainCourse(),
    desserts(),
    beverages(),
    snacks(),
  ];
}
