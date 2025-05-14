// validate form
/// Lớp chứa các hàm validate form dùng chung
class Validators {
  /// Validate rằng giá trị không được để trống
  /// Trả về message lỗi nếu rỗng, ngược lại trả về null
  static String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Không được để trống';
    }
    return null;
  }

  static String? validateTaxCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mã số thuế không được để trống';
    }
    return null;
  }

  static String? validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tài khoản không được để trống';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null ||
        value.isEmpty ||
        value.length < 6 ||
        value.length > 50) {
      return 'Mật khẩu phải từ 6 đến 50 ký tự';
    }

    return null;
  }

  /// TODO: thêm hàm validate email, số điện thoại, mật khẩu mạnh...
}
