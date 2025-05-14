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
}
