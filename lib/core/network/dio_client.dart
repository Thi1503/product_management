// core/network/dio_client.dart

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:product_management/core/constants.dart';
import 'package:product_management/core/hive/hive_service.dart';

class DioClient {
  final Dio dio;

  DioClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: Constants.apiBaseUrl,
          connectTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 60),
          // receiveTimeout: const Duration(seconds: 120),
        ),
      ) {
    // 1) Thêm LogInterceptor để log toàn bộ request/response
    dio.interceptors.add(
      LogInterceptor(requestHeader: true, requestBody: true),
    );

    // 2) Thêm Interceptor để tự động thêm token vào header
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final hive = GetIt.I<HiveService>();
          final token =
              hive.getAuthBox().get(Constants.authTokenKey)?.toString().trim();
          if (token != null && token.isNotEmpty) {
            // gửi đúng theo Postman: chỉ mình token
            options.headers['Authorization'] = token;
          }
          handler.next(options);
        },
      ),
    );
  }
}
