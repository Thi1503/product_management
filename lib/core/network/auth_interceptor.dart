import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:product_management/core/constants.dart';
import 'package:product_management/core/hive/hive_service.dart';

class AuthInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final hive = GetIt.I<HiveService>();
    final token =
        hive.getAuthBox().get(Constants.authTokenKey)?.toString().trim();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = token;
    }
    handler.next(options);
  }
}
