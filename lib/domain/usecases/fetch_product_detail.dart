import 'package:product_management/domain/entities/product.dart';
import 'package:product_management/domain/repositories/product_repository.dart';

class FetchProductDetail {
  final ProductRepository productRepository;

  FetchProductDetail(this.productRepository);

  Future<Product?> call(int productId) async {
    return await productRepository.fetchProductById(productId);
  }
}
