import 'package:dartz/dartz.dart';
import 'package:getxwithmvvmdemo/domain/entities/product/product.dart';
import '../../core/error/failures.dart';
import '../../data/models/product/product_model.dart';


abstract interface class ProductRepository {
  Future<Either<Failure, ProductsPage>> getProducts({
    required int limit,
    required int skip,
  });

  Future<Either<Failure,Product>> getProductById(int id);
}