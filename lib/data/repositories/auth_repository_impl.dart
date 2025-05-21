// lib/data/repositories/auth_repository_impl.dart

import 'package:dio/dio.dart';
import '../../core/constants.dart';
import '../../core/hive/hive_service.dart';

import '../datasources/auth_remote.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Implementation của AuthRepository dùng DataSource và Hive để lưu token
class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final HiveService _hive;

  AuthRepositoryImpl({required Dio dio, required HiveService hive})
    : _dio = dio,
      _hive = hive;

  /// Gọi login, lưu token vào Hive và trả về domain-entity User

  @override
  Future<User> login(String taxCode, String username, String password) async {
    // gọi API, nhận về UserModel
    final userModel = await AuthRemote(_dio).login(taxCode, username, password);

    // lưu token
    await _hive.getAuthBox().put(Constants.authTokenKey, userModel.token);
    // debug: in ra console token vừa nhận
    print('🔑 [Auth] Received & stored token: ${userModel.token}');

    // lưu taxCode
    await _hive.getAuthBox().put(Constants.savedTaxCodeKey, taxCode);
    // lưu username
    await _hive.getAuthBox().put(Constants.savedUserKey, username);

    // map sang domain entity
    return User(token: userModel.token);
  }

  /// Xóa token đăng nhập
  @override
  void logout() {
    final box = _hive.getAuthBox();
    box.delete(Constants.authTokenKey);
    // giữ nguyên savedTaxCodeKey & savedUserKey
  }
}
