import '../entities/user.dart';

/// Interface repository Authentication
/// Định nghĩa các phương thức liên quan đến authentication
abstract class AuthRepository {
  /// Đăng nhập, trả về User nếu thành công
  Future<User> login(String taxCode, String username, String password);

  /// Đăng xuất, xóa token local
  void logout();
}
