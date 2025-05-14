// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'core/bloc/bloc_observer.dart';
import 'core/hive/hive_service.dart';
import 'core/network/dio_client.dart';

import 'data/repositories/auth_repository_impl.dart';
import 'domain/usecases/login_usecase.dart';

import 'presentation/viewmodels/login/login_bloc.dart';
import 'presentation/views/login_page.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();

  // Đăng ký dependencies
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

  // Cung cấp LoginBloc ở gốc app
  runApp(
    BlocProvider<LoginBloc>(
      create: (_) => getIt<LoginBloc>(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
    );
  }
}
