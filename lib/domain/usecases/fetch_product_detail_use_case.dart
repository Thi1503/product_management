import 'package:product_management/domain/entities/product.dart';
import 'package:product_management/domain/repositories/product_repository.dart';

/// Use case để lấy chi tiết sản phẩm
/// Sử dụng ProductRepository để thực hiện việc này
class FetchProductDetailUseCase {
  final ProductRepository productRepository;

  FetchProductDetailUseCase(this.productRepository);

  /// Lấy chi tiết sản phẩm từ repository
  Future<Product> call(int productId) {
    return productRepository.fetchProductById(productId);
  }

  /// Xóa sản phẩm từ repository
  Future<void> deleteProduct(int productId) {
    return productRepository.deleteProduct(productId);
  }
}
