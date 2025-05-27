// lib/data/repositories/product_repository_impl.dart

import 'package:product_management/core/hive/hive_service.dart';
import 'package:product_management/data/datasources/product_remote.dart';
import 'package:product_management/data/models/product_model.dart';
import 'package:product_management/domain/entities/product.dart';
import 'package:product_management/domain/repositories/product_repository.dart';

/// Triển khai ProductRepository
/// Sử dụng ProductRemote để gọi API và HiveService để cache dữ liệu
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemote _remote;
  final HiveService _hive;

  ProductRepositoryImpl({
    required ProductRemote remote,
    required HiveService hive,
  }) : _remote = remote,
       _hive = hive;

  /// Lấy danh sách sản phẩm với phân trang
  @override
  Future<List<Product>> fetchProducts(int page, int size) async {
    final productModels = await _remote.fetchProducts(page, size);
    return productModels.map((model) => model.toProduct()).toList();
  }

  /// Lấy chi tiết sản phẩm, ưu tiên cache
  @override
  Future<Product> fetchProductById(int id) async {
    final box = _hive.getProductBox();
    try {
      final productModel = await _remote.fetchProductById(id);
      if (productModel == null) {
        throw Exception('Sản phẩm không tồn tại');
      }
      await box.put(id, productModel);
      return productModel.toProduct();
    } catch (_) {
      final cachedModel = box.get(id);
      if (cachedModel != null) {
        return cachedModel.toProduct();
      }
      rethrow;
    }
  }

  /// Xóa sản phẩm và xóa khỏi cache
  @override
  Future<void> deleteProduct(int id) async {
    await _remote.deleteProduct(id);
    await _hive.getProductBox().delete(id);
  }

  /// Tạo sản phẩm mới và cache không đồng bộ
  @override
  Future<Product> createProduct(ProductModel productModel) async {
    final createdModel = await _remote.createProduct(productModel);
    Future.microtask(
      () => _hive.getProductBox().put(createdModel.id, createdModel),
    );
    return createdModel.toProduct();
  }

  /// Cập nhật sản phẩm và cache không đồng bộ
  @override
  Future<Product> updateProduct(ProductModel productModel) async {
    final updatedModel = await _remote.updateProduct(productModel);
    Future.microtask(
      () => _hive.getProductBox().put(productModel.id, updatedModel),
    );
    return updatedModel.toProduct();
  }
}
