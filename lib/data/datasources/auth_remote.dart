import 'package:dio/dio.dart';
import 'package:product_management/data/models/base_response.dart';
import '../models/user_model.dart';

/// Data source gọi API liên quan tới Authentication
class AuthRemote {
  /// Instance Dio để thực hiện HTTP requests
  final Dio dio;

  AuthRemote(this.dio);

  /// Gửi request đăng nhập với taxCode, username, password
  /// Trả về UserModel khi thành công, ném exception nếu lỗi
  Future<UserModel> login(
    String taxCode,
    String username,
    String password,
  ) async {
    final resp = await dio.post(
      '/login2',
      data: {
        'tax_code': int.parse(taxCode),
        'user_name': username,
        'password': password,
      },
    );
    final json = resp.data;
    if (json == null) {
      throw Exception('Invalid response format');
    }
    // Sử dụng BaseResponse để kiểm tra thành công/thất bại
    final baseResp = BaseResponse<UserModel>.fromJson(
      json,
      (data) => UserModel.fromJson(data as Map<String, dynamic>),
    );
    if (baseResp.success != true) {
      // Nếu API trả về lỗi, ném exception với message từ server
      throw Exception(baseResp.message);
    }
    return baseResp.data;
  }
}
