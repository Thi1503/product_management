import 'package:product_management/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchProducts(int page, int size);
  Future<Product?> fetchProductById(int id);
}
