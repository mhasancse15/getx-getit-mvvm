import 'package:dartz/dartz.dart';
import 'package:getxwithmvvmdemo/domain/repositories/product_repository.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/product/product.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product/product_model.dart';

final class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({
    required this._productRemoteDataSource,
    required this._networkInfo,
  });

  final ProductRemoteDataSource _productRemoteDataSource;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, ProductsPage>> getProducts({
    required int limit,
    required int skip,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return left(const NoInternetFailure());
      }

      final response = await _productRemoteDataSource.getProducts(
        limit: limit,
        skip: skip,
      );
      return right(
        ProductsPage(
          products: response.products
              .map((model) => model.toEntity())
              .toList(growable: false),
          total: response.total,
          skip: response.skip,
          limit: response.limit,
        ),
      );
    } on NoInternetException catch (error) {
      return left(NoInternetFailure(error.message));
    } on ConnectionTimeoutException catch (error) {
      return left(TimeoutFailure(error.message));
    } on ReceiveTimeoutException catch (error) {
      return left(TimeoutFailure(error.message));
    } on SendTimeoutException catch (error) {
      return left(TimeoutFailure(error.message));
    } on BadRequestException catch (error) {
      return left(BadRequestFailure(error.message));
    } on UnauthorizedException catch (error) {
      return left(UnauthorizedFailure(error.message));
    } on NotFoundException catch (error) {
      return left(NotFoundFailure(error.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    } on UnknownDioException catch (error) {
      return left(UnexpectedFailure(error.message));
    } catch (error) {
      return left(UnexpectedFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure,Product>> getProductById(int id) async {
    try {
      if (!await _networkInfo.isConnected) {
        return left(const NoInternetFailure());
      }

      final response = await _productRemoteDataSource.getProductById(id = id);
      return right(
        response.toEntity(),
      );
    } on NoInternetException catch (error) {
      return left(NoInternetFailure(error.message));
    } on ConnectionTimeoutException catch (error) {
      return left(TimeoutFailure(error.message));
    } on ReceiveTimeoutException catch (error) {
      return left(TimeoutFailure(error.message));
    } on SendTimeoutException catch (error) {
      return left(TimeoutFailure(error.message));
    } on BadRequestException catch (error) {
      return left(BadRequestFailure(error.message));
    } on UnauthorizedException catch (error) {
      return left(UnauthorizedFailure(error.message));
    } on NotFoundException catch (error) {
      return left(NotFoundFailure(error.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    } on UnknownDioException catch (error) {
      return left(UnexpectedFailure(error.message));
    } catch (error) {
      return left(UnexpectedFailure(error.toString()));
    }
  }
}
