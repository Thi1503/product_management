class ProductModel {
  final int id;
  final String name;
  final double price;
  final int quantity;
  final String cover;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.cover,
  });

  /// Tạo từ JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      cover: json['cover'] as String,
    );
  }

  /// Chuyển sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'cover': cover,
    };
  }
}
