import 'package:dio/dio.dart';
import 'package:product_management/data/models/base_response_list.dart';
import 'package:product_management/data/models/product_model.dart';
import 'package:product_management/data/models/base_response.dart';

/// Data source xử lý các request liên quan đến sản phẩm (Product)
/// Thực hiện các thao tác CRUD với API backend sử dụng Dio
class ProductRemote {
  final Dio dio;

  /// Khởi tạo với một instance Dio để thực hiện HTTP requests
  ProductRemote(this.dio);

  /// Gửi request lấy danh sách sản phẩm từ API
  /// [page], [size]: tham số phân trang (nếu backend hỗ trợ)
  /// Trả về danh sách ProductModel
  Future<List<ProductModel>> fetchProducts(int page, int size) async {
    try {
      final resp = await dio.get('/products');
      final baseResp = BaseResponseList<ProductModel>.fromJson(
        resp.data,
        (e) => ProductModel.fromJson(e as Map<String, dynamic>),
      );
      return baseResp.data; // Trả về List<ProductModel>
    } on DioException catch (e) {
      // Bắt lỗi từ Dio (network, timeout, server error…)
      final msg = e.response?.data['message'] ?? e.message;
      throw Exception('Failed to fetch products: $msg');
    } catch (e) {
      // Bắt lỗi khác
      throw Exception('Unexpected error: $e');
    }
  }

  /// Gửi request lấy chi tiết sản phẩm dựa vào id
  /// [id]: id của sản phẩm cần lấy
  /// Trả về ProductModel hoặc null nếu không tìm thấy
  Future<ProductModel?> fetchProductById(int id) async {
    try {
      final resp = await dio.get('/products/$id');
      if (resp.statusCode == 404) return null;
      final baseResp = BaseResponse<ProductModel>.fromJson(
        resp.data,
        (data) => ProductModel.fromJson(data as Map<String, dynamic>),
      );
      return baseResp.data;
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? e.message;
      throw Exception('Failed to fetch product: $msg');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Gửi request xóa sản phẩm dựa vào id
  /// [id]: id của sản phẩm cần xóa
  /// Trả về null nếu thành công, throw Exception nếu thất bại
  Future<void> deleteProduct(int id) async {
    try {
      final resp = await dio.delete('/products/$id');
      final baseResp = BaseResponse<dynamic>.fromJson(resp.data, (_) => null);
      if (baseResp.success != true) {
        throw Exception('Failed to delete product: ${baseResp.message}');
      }
    } on DioException catch (e) {
      final msg = e.response?.data['message'] ?? e.message;
      throw Exception('Failed to delete product: $msg');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Gửi request tạo mới sản phẩm
  /// [product]: thông tin sản phẩm cần tạo
  /// Trả về ProductModel vừa được tạo thành công
  Future<ProductModel> createProduct(ProductModel product) async {
    final response = await dio.post('/products', data: product.toJson());
    final baseResp = BaseResponse<ProductModel>.fromJson(
      response.data,
      (data) => ProductModel.fromJson(data as Map<String, dynamic>),
    );
    return baseResp.data;
  }

  /// Gửi request cập nhật sản phẩm
  /// [product]: thông tin sản phẩm đã chỉnh sửa
  /// Trả về ProductModel đã được cập nhật thành công
  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await dio.put(
      '/products/${product.id}',
      data: product.toJson(),
    );
    final baseResp = BaseResponse<ProductModel>.fromJson(
      response.data,
      (data) => ProductModel.fromJson(data as Map<String, dynamic>),
    );
    return baseResp.data;
  }
}
