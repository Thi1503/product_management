import 'package:get_it/get_it.dart';
import 'package:product_management/core/hive/hive_service.dart';
import 'package:product_management/core/network/dio_client.dart';
import 'package:product_management/data/datasources/auth_remote.dart';
import 'package:product_management/data/datasources/product_remote.dart';
import 'package:product_management/data/repositories/auth_repository_impl.dart';
import 'package:product_management/data/repositories/product_repository_impl.dart';
import 'package:product_management/domain/usecases/create_product_use_case.dart';
import 'package:product_management/domain/usecases/fetch_product_detail_use_case.dart';
import 'package:product_management/domain/usecases/fetch_products_use_case.dart';
import 'package:product_management/domain/usecases/login_use_case.dart';
import 'package:product_management/domain/usecases/update_product_use_case.dart';
import 'package:product_management/presentation/viewmodels/login/login_bloc.dart';
import 'package:product_management/presentation/viewmodels/product_detail/product_detail_cubit.dart';
import 'package:product_management/presentation/viewmodels/product_form/product_form_cubit.dart';
import 'package:product_management/presentation/viewmodels/product_list/product_list_cubit.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  getIt.registerLazySingleton<DioClient>(() => DioClient());
  getIt.registerLazySingleton<HiveService>(() => HiveService());

  // Data sources: phải register trước khi repository dùng
  getIt.registerLazySingleton<AuthRemote>(
    () => AuthRemote(getIt<DioClient>().dio),
  );

  getIt.registerLazySingleton<ProductRemote>(
    () => ProductRemote(getIt<DioClient>().dio),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepositoryImpl>(
    () => AuthRepositoryImpl(
      remote: getIt<AuthRemote>(),
      hive: getIt<HiveService>(),
    ),
  );
  getIt.registerLazySingleton<ProductRepositoryImpl>(
    () => ProductRepositoryImpl(
      remote: getIt<ProductRemote>(),
      hive: getIt<HiveService>(),
    ),
  );

  // Use cases
  getIt.registerFactory<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepositoryImpl>()),
  );
  getIt.registerFactory<FetchProductsUseCase>(
    () => FetchProductsUseCase(getIt<ProductRepositoryImpl>()),
  );
  getIt.registerFactory<FetchProductDetailUseCase>(
    () => FetchProductDetailUseCase(getIt<ProductRepositoryImpl>()),
  );
  getIt.registerFactory<UpdateProductUseCase>(
    () => UpdateProductUseCase(getIt<ProductRepositoryImpl>()),
  );
  getIt.registerFactory<CreateProductUseCase>(
    () => CreateProductUseCase(getIt<ProductRepositoryImpl>()),
  );

  // Blocs / Cubits
  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(loginUseCase: getIt<LoginUseCase>()),
  );
  getIt.registerFactory<ProductListCubit>(
    () => ProductListCubit(fetchProducts: getIt<FetchProductsUseCase>()),
  );
  getIt.registerFactory<ProductDetailCubit>(
    () => ProductDetailCubit(fetchDetail: getIt<FetchProductDetailUseCase>()),
  );
  getIt.registerFactory<ProductFormCubit>(
    () => ProductFormCubit(
      createProductUseCase: getIt<CreateProductUseCase>(),
      updateProductUseCase: getIt<UpdateProductUseCase>(),
    ),
  );
}
