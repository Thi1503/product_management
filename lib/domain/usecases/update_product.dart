import 'package:product_management/data/models/models.dart';
import 'package:product_management/domain/entities/product.dart';
import 'package:product_management/domain/repositories/product_repository.dart';

///Usecase câp nhật sản phẩm
class UpdateProduct {
  final ProductRepository _repository;

  UpdateProduct(this._repository);

  Future<Product> call(ProductModel product) {
    return _repository.updateProduct(product);
  }
}
