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

  /// Validate rằng mã số thuế không được để trống
  static String? validateTaxCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mã số thuế không được để trống';
    }
    return null;
  }

  ///Varlidate rằng tên không được để trống
  static String? validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tài khoản không được để trống';
    }
    return null;
  }

  /// Varlidate rằng mật khẩu phảitừ 6 đến 50 ký tự
  static String? validatePassword(String? value) {
    if (value == null ||
        value.isEmpty ||
        value.length < 6 ||
        value.length > 50) {
      return 'Mật khẩu phải từ 6 đến 50 ký tự';
    }

    return null;
  }

  /// Validate rằng tên sản phẩm không được để trống
  static String? validateProductName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập tên sản phẩm';
    }
    return null;
  }

  //// Validate rằng giá sản phẩm không được để trống và phải là số dương
  static String? validateProductPrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập giá';
    }
    final price = int.tryParse(value);
    if (price == null || price < 0) {
      return 'Giá không hợp lệ';
    }
    return null;
  }

  /// Validate rằng số lượng sản phẩm không được để trống và phải là số dương
  static String? validateProductQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số lượng';
    }
    final qty = int.tryParse(value);
    if (qty == null || qty < 0) {
      return 'Số lượng không hợp lệ';
    }
    return null;
  }

  /// Validate rằng link ảnh không được để trống và phải là link hợp lệ
  static String? validateProductCover(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập link ảnh';
    }
    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasAbsolutePath) {
      return 'Link không hợp lệ';
    }
    return null;
  }
}
