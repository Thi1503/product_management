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

  /// TODO: thêm hàm validate email, số điện thoại, mật khẩu mạnh...
}
