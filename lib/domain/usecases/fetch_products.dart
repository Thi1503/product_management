import 'package:product_management/domain/entities/product.dart';
import 'package:product_management/domain/repositories/product_repository.dart';

class FetchProducts {
  final ProductRepository productRepository;

  FetchProducts(this.productRepository);

  Future<List<Product>> call(int page, int size) async {
    return await productRepository.fetchProducts(page, size);
  }
}
