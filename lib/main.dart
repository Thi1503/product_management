// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:product_management/domain/usecases/create_product.dart';
import 'package:product_management/domain/usecases/fetch_product_detail.dart';
import 'package:product_management/domain/usecases/update_product.dart';
import 'package:product_management/presentation/viewmodels/product_detail/product_detail_cubit.dart';
import 'package:product_management/presentation/viewmodels/product_form/product_form_cubit.dart';
import 'package:product_management/presentation/views/my_app.dart';

import 'core/bloc/bloc_observer.dart';
import 'core/hive/hive_service.dart';
import 'core/network/dio_client.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/usecases/fetch_products.dart';
import 'domain/usecases/login_usecase.dart';
import 'presentation/viewmodels/login/login_bloc.dart';
import 'presentation/viewmodels/product_list/product_list_cubit.dart';

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
  getIt.registerLazySingleton<FetchProductDetail>(
    () => FetchProductDetail(getIt<ProductRepositoryImpl>()),
  );
  getIt.registerLazySingleton<UpdateProduct>(
    () => UpdateProduct(getIt<ProductRepositoryImpl>()),
  );
  getIt.registerLazySingleton<CreateProduct>(
    () => CreateProduct(getIt<ProductRepositoryImpl>()),
  );

  // 4) Blocs / Cubits
  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(loginUseCase: getIt<LoginUseCase>()),
  );
  getIt.registerFactory<ProductListCubit>(
    () => ProductListCubit(fetchProducts: getIt<FetchProducts>()),
  );

  getIt.registerFactory<ProductDetailCubit>(
    () => ProductDetailCubit(fetchDetail: getIt<FetchProductDetail>()),
  );
  getIt.registerFactory<ProductFormCubit>(
    () => ProductFormCubit(
      createProductUseCase: getIt<CreateProduct>(),
      updateProductUseCase: getIt<UpdateProduct>(),
    ),
  );

  runApp(const MyApp());
}
