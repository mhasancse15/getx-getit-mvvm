import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../data/datasources/product_remote_data_source.dart';
import '../../data/datasources/user_remote_data_source.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/get_users.dart';
import '../../domain/usecases/search_user.dart';
import '../../presentation/controllers/product_controller.dart';
import '../../presentation/controllers/product_details_controller.dart';
import '../../presentation/controllers/user_controller.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  if (getIt.isRegistered<Dio>()) return;

  getIt.registerLazySingleton<Dio>(DioClient.create);
  getIt.registerLazySingleton<InternetConnection>(InternetConnection.new);
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt<InternetConnection>()),
  );

  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: getIt<UserRemoteDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );
  getIt.registerLazySingleton<GetUsers>(
    () => GetUsers(getIt<UserRepository>()),
  );
  getIt.registerFactory<UserController>(
    () => UserController(getIt<GetUsers>()),
  );

  getIt.registerLazySingleton<SearchUsers>(
    () => SearchUsers(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(getIt<Dio>()),
  );

  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      productRemoteDataSource: getIt<ProductRemoteDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );
  getIt.registerLazySingleton<GetProducts>(
    () => GetProducts(getIt<ProductRepository>()),
  );
  getIt.registerFactory<ProductController>(
    () => ProductController(getIt<GetProducts>()),
  );

  getIt.registerLazySingleton<GetProductById>(
    () => GetProductById(getIt<ProductRepository>()),
  );
  getIt.registerFactory<ProductDetailsController>(
    () => ProductDetailsController(getIt<GetProductById>()),
  );
}
