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
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final hive = GetIt.I<HiveService>();
          final token = hive.getAuthBox().get(Constants.authTokenKey);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }
}
