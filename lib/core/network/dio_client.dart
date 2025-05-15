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
    // 1) Thêm LogInterceptor để log toàn bộ request/response
    dio.interceptors.add(
      LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
      ),
    );

    // 2) Sửa onRequest để in URI + headers trước khi gửi
    // dio.interceptors.add(
    //   InterceptorsWrapper(
    //     onRequest: (options, handler) {
    //       final hive = GetIt.I<HiveService>();
    //       final token =
    //           hive.getAuthBox().get(Constants.authTokenKey)?.toString().trim();

    //       // Debug info
    //       print('→ [Dio] Request: ${options.method} ${options.uri}');
    //       print('→ [Dio] Before setting auth headers: ${options.headers}');
    //       print('→ [Dio] Using token: $token');

    //       if (token != null && token.isNotEmpty) {
    //         options.headers['Authorization'] = 'Bearer $token';
    //       }

    //       print('→ [Dio] Final headers: ${options.headers}');
    //       handler.next(options);
    //     },
    //   ),
    // );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final hive = GetIt.I<HiveService>();
          final token =
              hive.getAuthBox().get(Constants.authTokenKey)?.toString().trim();
          if (token != null && token.isNotEmpty) {
            // gửi đúng theo Postman: chỉ mình token, không kèm "Bearer "
            options.headers['Authorization'] = token;
          }
          handler.next(options);
        },
      ),
    );
  }
}
