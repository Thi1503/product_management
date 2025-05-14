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
      // Chuyển sang domain entity Product
      return models
          .map(
            (m) => Product(
              id: m.id,
              name: m.name,
              price: m.price,
              quantity: m.quantity,
              cover: m.cover,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }
}
