// core/network/dio_client.dart

import 'package:dio/dio.dart';
import 'package:product_management/core/constants.dart';
import 'package:product_management/core/network/auth_interceptor.dart';

class DioClient {
  final Dio dio;

  DioClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: Constants.apiBaseUrl,
          connectTimeout: const Duration(seconds: 120),
          sendTimeout: const Duration(seconds: 5),
        ),
      ) {
    // 1) Thêm LogInterceptor để log toàn bộ request/response
    dio.interceptors.add(
      LogInterceptor(requestHeader: true, requestBody: true),
    );

    // 2) Thêm AuthInterceptor để tự động thêm token vào header
    dio.interceptors.add(AuthInterceptor());
  }
}
