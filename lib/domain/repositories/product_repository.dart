import 'package:dartz/dartz.dart';
import 'package:getxwithmvvmdemo/domain/entities/product/product.dart';
import '../../core/error/failures.dart';


abstract interface class ProductRepository {
  Future<Either<Failure, ProductsPage>> getProducts({
    required int limit,
    required int skip,
  });
}