class Product {
  final int id;
  final String name;
  final int price;
  final int quantity;
  final String cover;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.cover,
  });

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, quantity: $quantity, cover: $cover)';
  }
}
