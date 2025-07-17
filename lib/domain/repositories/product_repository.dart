import 'package:product_management/data/models/models.dart';
import 'package:product_management/domain/entities/product.dart';

///Interface cho ProductRepository
/// Đây là nơi định nghĩa các phương thức mà repository sẽ triển khai
abstract class ProductRepository {
  Future<List<Product>> fetchProducts(int page, int size);
  Future<Product> fetchProductById(int id);
  Future<void> deleteProduct(int id);
  Future<Product> createProduct(ProductModel product);
  Future<Product> updateProduct(ProductModel product);
}
