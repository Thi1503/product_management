import 'package:product_management/data/models/models.dart';
import 'package:product_management/domain/entities/product.dart';
import 'package:product_management/domain/repositories/product_repository.dart';

class CreateProduct {
  final ProductRepository _repository;

  CreateProduct(this._repository);

  Future<Product> call(ProductModel product) {
    return _repository.createProduct(product);
  }
}
