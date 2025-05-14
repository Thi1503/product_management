// init, box mở sẵn token, cache
import 'package:hive_flutter/hive_flutter.dart';

/// Lớp xử lý khởi tạo và truy xuất các Hive box
class HiveService {
  /// Tên box lưu thông tin xác thực (token, user)
  static const String authBox = 'authBox';

  /// Tên box cache chi tiết sản phẩm
  static const String productCacheBox = 'productCache';

  /// Khởi tạo Hive và mở các box cần thiết
  /// Gọi `await HiveService.init()` trong main()
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(authBox);
    await Hive.openBox(productCacheBox);
  }

  /// Lấy hộp lưu authentication
  Box getAuthBox() => Hive.box(authBox);

  /// Lấy hộp cache sản phẩm
  Box getProductBox() => Hive.box(productCacheBox);
}
