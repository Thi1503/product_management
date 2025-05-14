// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'core/bloc/bloc_observer.dart';
import 'core/hive/hive_service.dart';
import 'core/network/dio_client.dart';

import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';

import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/fetch_products.dart';

import 'presentation/viewmodels/login/login_bloc.dart';
import 'presentation/viewmodels/product_list/product_list_cubit.dart';

import 'presentation/views/login_page.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await HiveService.init();

  // 1) Core
  getIt.registerLazySingleton<DioClient>(() => DioClient());
  getIt.registerLazySingleton<HiveService>(() => HiveService());

  // 2) Repositories
  getIt.registerLazySingleton<AuthRepositoryImpl>(
    () => AuthRepositoryImpl(
      dio: getIt<DioClient>().dio,
      hive: getIt<HiveService>(),
    ),
  );
  getIt.registerLazySingleton<ProductRepositoryImpl>(
    () => ProductRepositoryImpl(
      dio: getIt<DioClient>().dio,
      hive: getIt<HiveService>(),
    ),
  );

  // 3) Use cases
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepositoryImpl>()),
  );
  getIt.registerLazySingleton<FetchProducts>(
    () => FetchProducts(getIt<ProductRepositoryImpl>()),
  );

  // 4) Blocs / Cubits
  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(loginUseCase: getIt<LoginUseCase>()),
  );
  getIt.registerFactory<ProductListCubit>(
    () => ProductListCubit(fetchProducts: getIt<FetchProducts>()),
  );

  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginBloc>(),
      child: const MyApp(),
    );
  }
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
