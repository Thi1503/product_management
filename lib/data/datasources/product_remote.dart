import 'package:dio/dio.dart';
import 'package:product_management/data/models/product_model.dart';

class ProductRemote {
  final Dio dio;
  ProductRemote(this.dio);

  /// Gửi request lấy danh sách sản phẩm
  /// Trả về danh sách ProductModel
  Future<List<ProductModel>> fetchProducts(int page, int size) async {
    try {
      final resp = await dio.get(
        '/products',
        queryParameters: {'page': page, 'size': size},
      );

      final data = resp.data?['data'];
      if (data == null || data is! List) {
        throw Exception('Invalid response format: ${resp.data}');
      }

      return data
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      // Bắt lỗi từ Dio (network, timeout, server error…)
      final msg = e.response?.data['message'] ?? e.message;
      throw Exception('Failed to fetch products: $msg');
    } catch (e) {
      // Bắt lỗi khác
      throw Exception('Unexpected error: $e');
    }
  }

  ///Gửi request lấy chi tiết sản phẩm dựa vào id
  ///Trả về ProductModel
  ///Nếu không tìm thấy sản phẩm, trả về null
  ///Nếu có lỗi, ném ra Exception
  Future<ProductModel?> fetchProductById(int id) async {
    try {
      final resp = await dio.get('/products/$id');
      if (resp.statusCode == 200) {
        return ProductModel.fromJson(resp.data);
      } else if (resp.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to fetch product: ${resp.data}');
      }
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? e.message;
      throw Exception('Failed to fetch product: $msg');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  ///Gửi request xóa sản phẩm dựa vào id
  ///Trả về null
  Future<void> deleteProduct(int id) async {
    try {
      final resp = await dio.delete('/products/$id');
      if (resp.statusCode != 200) {
        throw Exception('Failed to delete product: ${resp.data}');
      }
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? e.message;
      throw Exception('Failed to delete product: $msg');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Tạo mới sản phẩm
  Future<ProductModel> createProduct(ProductModel product) async {
    final response = await dio.post('/products', data: product.toJson());
    return ProductModel.fromJson(response.data);
  }

  /// Cập nhật sản phẩm
  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await dio.put(
      '/products/${product.id}',
      data: product.toJson(),
    );
    return ProductModel.fromJson(response.data);
  }
}
