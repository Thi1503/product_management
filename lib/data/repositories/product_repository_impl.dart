import 'package:dio/dio.dart';
import 'package:product_management/core/hive/hive_service.dart';
import 'package:product_management/data/datasources/product_remote.dart';
import 'package:product_management/domain/entities/product.dart';
import 'package:product_management/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final Dio _dio;
  final HiveService _hive;

  ProductRepositoryImpl({required Dio dio, required HiveService hive})
    : _dio = dio,
      _hive = hive;

  /// Lấy danh sách sản phẩm với paging, không cache
  @override
  Future<List<Product>> fetchProducts(int page, int size) async {
    try {
      // Gọi API lấy danh sách ProductModel
      final models = await ProductRemote(_dio).fetchProducts(page, size);
      // Dùng toProduct() để chuyển sang domain entity
      return models.map((m) => m.toProduct()).toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  /// Lấy chi tiết sản phẩm, ưu tiên cache local, nếu không có thì gọi API
  @override
  Future<Product> fetchProductById(int id) async {
    final box = _hive.getProductBox();

    try {
      // 1) Gọi API lấy chi tiết sản phẩm mới nhất
      final model = await ProductRemote(_dio).fetchProductById(id);
      if (model == null) {
        throw Exception('Product not found');
      }

      // 2) Lưu model vào cache (cập nhật cache)
      await box.put(id, model);

      // 3) Trả về domain entity
      return model.toProduct();
    } catch (e) {
      // Nếu gọi API lỗi, fallback trả về cache nếu có
      final cachedModel = box.get(id);
      if (cachedModel != null) {
        return cachedModel.toProduct();
      }
      throw Exception('Failed to fetch product: $e');
    }
  }

  /// Lấy chi tiết, ưu tiên cache local
}
