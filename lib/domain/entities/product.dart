import 'package:equatable/equatable.dart';

/// This class represents a product entity with its properties.
class Product extends Equatable {
  final int id;
  final String name;
  final int price;
  final int quantity;
  final String cover;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.cover,
  });

  @override
  List<Object?> get props => [id, name, price, quantity, cover];

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, quantity: $quantity, cover: $cover)';
  }
}
