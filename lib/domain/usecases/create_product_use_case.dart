import 'package:product_management/data/models/models.dart';
import 'package:product_management/domain/entities/product.dart';
import 'package:product_management/domain/repositories/product_repository.dart';

/// Use case để tạo sản phẩm mới
/// Sử dụng ProductRepository để thực hiện việc này
class CreateProductUseCase {
  final ProductRepository _repository;

  CreateProductUseCase(this._repository);

  Future<Product> call(ProductModel product) {
    return _repository.createProduct(product);
  }
}
