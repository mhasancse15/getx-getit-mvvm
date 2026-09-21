import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../models/product/product_model.dart';
import '../models/product/products_response_model.dart';

abstract interface class ProductRemoteDataSource {
  Future<ProductsResponseModel> getProducts({
    required int limit,
    required int skip,
  });

  Future<ProductModel> getProductById(int id);
}

final class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  ProductRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<ProductsResponseModel> getProducts({
    required int limit,
    required int skip,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiConstants.products,
        queryParameters: <String, dynamic>{'limit': limit, 'skip': skip},
      );

      final statusCode = response.statusCode ?? 0;
      if (statusCode < 200 || statusCode >= 300) {
        throw _exceptionForStatus(statusCode);
      }
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const UnknownDioException(
          'The API response had an invalid format.',
        );
      }
      return ProductsResponseModel.fromJson(data);
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on AppException {
      rethrow;
    } on FormatException catch (error) {
      throw UnknownDioException(error.message);
    } catch (error) {
      throw UnknownDioException(error.toString());
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await _dio.get<dynamic>(
        '${ApiConstants.productById}$id',
      );

      final statusCode = response.statusCode ?? 0;
      if (statusCode < 200 || statusCode >= 300) {
        throw _exceptionForStatus(statusCode);
      }

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const FormatException('Invalid product response.');
      }

      return ProductModel.fromJson(data);
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on AppException {
      rethrow;
    } on FormatException catch (error) {
      throw UnknownDioException(error.message);
    } catch (error) {
      throw UnknownDioException(error.toString());
    }
  }

  AppException _mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return const ConnectionTimeoutException();
      case DioExceptionType.receiveTimeout:
        return const ReceiveTimeoutException();
      case DioExceptionType.sendTimeout:
        return const SendTimeoutException();
      case DioExceptionType.connectionError:
        return const NoInternetException();
      case DioExceptionType.badResponse:
        return _exceptionForStatus(error.response?.statusCode ?? 0);
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
      case DioExceptionType.transformTimeout:
        return UnknownDioException(_sanitizeMessage(error.message));
    }
  }

  AppException _exceptionForStatus(int statusCode) {
    switch (statusCode) {
      case 400:
        return const BadRequestException();
      case 401:
      case 403:
        return const UnauthorizedException();
      case 404:
        return const NotFoundException();
      case 500:
      case 501:
      case 502:
      case 503:
      case 504:
        return const ServerException();
      default:
        return UnknownDioException('Unexpected HTTP status: $statusCode');
    }
  }

  String _sanitizeMessage(String? message) {
    if (message == null) return 'An unexpected network error occurred.';
    final trimmed = message.trim();
    if (trimmed.isEmpty) return 'An unexpected network error occurred.';
    // Avoid returning terse or non-descriptive tokens that may come from Dio internals
    const badTokens = <String>{'response', 'error', 'null'};
    if (badTokens.contains(trimmed.toLowerCase()))
      return 'An unexpected network error occurred.';
    return trimmed;
  }
}
