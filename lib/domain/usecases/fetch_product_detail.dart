import 'package:product_management/domain/entities/product.dart';
import 'package:product_management/domain/repositories/product_repository.dart';

class FetchProductDetail {
  final ProductRepository productRepository;

  FetchProductDetail(this.productRepository);

  /// Lấy chi tiết sản phẩm từ repository
  Future<Product> call(int productId) {
    return productRepository.fetchProductById(productId);
  }

  /// Xóa sản phẩm từ repository
  Future<void> deleteProduct(int productId) {
    return productRepository.deleteProduct(productId);
  }
}
