// lib/core/hive/hive.dart

import 'package:hive_flutter/hive_flutter.dart';
import 'package:product_management/data/models/product_model.dart';

class HiveService {
  static const String authBox = 'authBox';
  static const String productCacheBox = 'productCache';

  /// Gọi 1 lần duy nhất khi khởi động app (trong main)
  static Future<void> init() async {
    await Hive.initFlutter();

    // Đăng ký adapter cho ProductModel
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ProductModelAdapter());
    } // Chỉ mở box nếu nó chưa được mở
    // To delete on startup (only during development!):
    // Then re-open:
    await Hive.openBox<ProductModel>(productCacheBox);
    if (!Hive.isBoxOpen(authBox)) {
      await Hive.openBox(authBox);
    }
  }

  Box getAuthBox() => Hive.box(authBox);
  Box<ProductModel> getProductBox() => Hive.box<ProductModel>(productCacheBox);
}
