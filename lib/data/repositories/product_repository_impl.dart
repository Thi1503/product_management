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

  /// Lấy chi tiết sản phẩm theo id và cache vào Hive
  @override
  Future<Product?> fetchProductById(int id) async {
    final box = _hive.getProductBox();

    try {
      // Kiểm tra xem sản phẩm đã được cache chưa
      final cachedModel = box.get(id);
      if (cachedModel != null) {
        return cachedModel.toProduct();
      }

      // Nếu chưa có trong cache, gọi API để lấy sản phẩm
      final model = await ProductRemote(_dio).fetchProductById(id);
      if (model == null) {
        throw Exception('Product not found');
      }

      // 3) Lưu vào cache
      await box.put(id, model);

      // Lưu vào cache
      _hive.getProductBox().put(id, model);

      // Chuyển sang domain entity Product
      // 4) Trả về domain entity
      return model.toProduct();
    } catch (e) {
      throw Exception('Failed to fetch product: $e');
    }
  }
}
