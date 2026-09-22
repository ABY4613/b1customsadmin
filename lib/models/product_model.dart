import '../utils/app_constants.dart';

class ProductModel {
  final String id;
  final String title;
  final String sku;
  final String category;
  final double price;
  final int stock;
  final String description;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.title,
    required this.sku,
    required this.category,
    required this.price,
    required this.stock,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isLowStock => stock <= AppConstants.lowStockThreshold && stock > 0;
  bool get isOutOfStock => stock <= 0;

  ProductModel copyWith({
    String? id,
    String? title,
    String? sku,
    String? category,
    double? price,
    int? stock,
    String? description,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      sku: sku ?? this.sku,
      category: category ?? this.category,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'sku': sku,
      'category': category,
      'price': price,
      'stock': stock,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> json, [String? docId]) {
    DateTime parseDate(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
      if (value.runtimeType.toString().contains('Timestamp')) {
        return value.toDate();
      }

      return DateTime.now();
    }

    return ProductModel(
      id: (docId != null && docId.isNotEmpty) ? docId : (json['id'] ?? ''),
      title: json['title'] ?? '',
      sku: json['sku'] ?? '',
      category: json['category'] ?? 'Exhaust',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel.fromMap(json, json['id']);
}

