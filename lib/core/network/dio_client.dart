// config Dio, interceptor thêm token
import 'package:dio/dio.dart';
import 'package:product_management/core/constants.dart';

/// Lớp cấu hình và khởi tạo Dio client dùng chung trong ứng dụng
/// Thêm interceptor để đính kèm token và log request/response
class DioClient {
  /// Instance của Dio đã cấu hình sẵn
  final Dio dio;

  /// Constructor: khởi tạo Dio với BaseOptions
  /// - baseUrl: URL gốc của API
  /// - connectTimeout: thời gian chờ kết nối (ms)
  /// - receiveTimeout: thời gian chờ phản hồi (ms)
  DioClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: Constants.apiBaseUrl,
          connectTimeout: const Duration(seconds: 5), // 5s để kết nối
          sendTimeout: const Duration(seconds: 5), // 5s để gửi request
        ),
      ) {
    // TODO: thêm interceptor (ví dụ: TokenInterceptor)
    // dio.interceptors.add( ... );
  }
}
