// lib/data/models/product_model.dart

import 'package:product_management/domain/entities/product.dart';

/// Mô hình dữ liệu cho sản phẩm
/// Chuyển đổi giữa JSON và ProductModel
class ProductModel {
  final int id;

  final String name;

  final int price;

  final int quantity;

  final String cover;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.cover,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map<String, dynamic>?) ?? json;
    int parseInt(dynamic v) =>
        v is num ? v.toInt() : int.tryParse(v?.toString() ?? '') ?? 0;
    return ProductModel(
      id: parseInt(data['id']),
      name: data['name'] as String? ?? '',
      price: parseInt(data['price']),
      quantity: parseInt(data['quantity']),
      cover: data['cover'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'price': price, 'quantity': quantity, 'cover': cover};
  }

  Product toProduct() => Product(
    id: id,
    name: name,
    price: price,
    quantity: quantity,
    cover: cover,
  );
}
