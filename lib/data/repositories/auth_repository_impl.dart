// lib/data/repositories/auth_repository_impl.dart

import '../../core/constants.dart';
import '../../core/hive/hive_service.dart';

import '../datasources/auth_remote.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemote _remote;
  final HiveService _hive;

  AuthRepositoryImpl({required AuthRemote remote, required HiveService hive})
    : _remote = remote,
      _hive = hive;

  @override
  Future<User> login(String taxCode, String username, String password) async {
    // bây giờ chỉ gọi lên tầng remote
    final userModel = await _remote.login(taxCode, username, password);

    await _hive.getAuthBox().put(Constants.authTokenKey, userModel.token);
    await _hive.getAuthBox().put(Constants.savedTaxCodeKey, taxCode);
    await _hive.getAuthBox().put(Constants.savedUserKey, username);

    return User(token: userModel.token);
  }

  @override
  void logout() {
    _hive.getAuthBox().delete(Constants.authTokenKey);
  }
}
