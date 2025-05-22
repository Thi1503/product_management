import 'package:hive/hive.dart';
import 'package:product_management/domain/entities/product.dart';

part 'product_model.g.dart';

@HiveType(typeId: 1)
class ProductModel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final int price;
  @HiveField(3)
  final int quantity;
  @HiveField(4)
  final String cover;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.cover,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as int,
      quantity: json['quantity'] as int,
      cover: json['cover'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'quantity': quantity,
        'cover': cover,
      };

  Product toProduct() => Product(
        id: id,
        name: name,
        price: price,
        quantity: quantity,
        cover: cover,
      );
}
