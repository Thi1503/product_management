import 'package:product_management/domain/entities/product.dart';
import 'package:product_management/domain/repositories/product_repository.dart';

/// Use case để lấy danh sách sản phẩm
/// Sử dụng ProductRepository để thực hiện việc này
class FetchProducts {
  final ProductRepository productRepository;

  FetchProducts(this.productRepository);

  Future<List<Product>> call(int page, int size) async {
    return await productRepository.fetchProducts(page, size);
  }
}
