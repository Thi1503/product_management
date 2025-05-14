import '../repositories/auth_repository.dart';
import '../entities/user.dart';

/// UseCase: Đăng nhập
class LoginUseCase {
  final AuthRepository repository;

  /// Constructor inject repository
  LoginUseCase(this.repository);

  /// Thực hiện login, trả về User
  Future<User> call(String taxCode, String username, String password) {
    return repository.login(taxCode, username, password);
  }
}
