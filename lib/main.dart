import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:product_management/core/bloc/bloc_observer.dart';
import 'core/hive/hive_service.dart';
import 'core/network/dio_client.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/usecases/login_usecase.dart';
import 'presentation/viewmodels/login/login_bloc.dart';
import 'presentation/views/login_page.dart';

/// GetIt instance  đăng ký dependencies
final getIt = GetIt.instance;

void main() async {
  // Đăng ký BlocObserver để theo dõi các sự kiện và trạng thái của Bloc
  Bloc.observer = SimpleBlocObserver();
  // Khởi tạo Flutter binding
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Hive để lưu trữ local
  await HiveService.init();

  // Đăng ký các dependency cho chức năng đăng nhập
  getIt.registerLazySingleton<DioClient>(() => DioClient());
  getIt.registerLazySingleton<HiveService>(() => HiveService());
  getIt.registerLazySingleton<AuthRepositoryImpl>(
    () => AuthRepositoryImpl(
      dio: getIt<DioClient>().dio,
      hive: getIt<HiveService>(),
    ),
  );
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepositoryImpl>()),
  );
  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(loginUseCase: getIt<LoginUseCase>()),
  );

  runApp(const MyApp());
}

/// Root widget of the application with only Login functionality
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Management - Login',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (_) => getIt<LoginBloc>(),
        child: const LoginPage(),
      ),
    );
  }
}
