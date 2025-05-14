import 'package:dio/dio.dart';
import '../models/user_model.dart';

/// Data source gọi API liên quan tới Authentication
class AuthRemote {
  /// Instance Dio để thực hiện HTTP requests
  final Dio dio;

  AuthRemote(this.dio);

  /// Gửi request đăng nhập với taxCode, username, password
  /// Trả về UserModel khi thành công
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
    if (json == null || json['data'] == null) {
      throw Exception('Invalid response format');
    }
    return UserModel.fromJson(json['data'] as Map<String, dynamic>);
  }
}
