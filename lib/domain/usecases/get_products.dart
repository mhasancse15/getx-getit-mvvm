import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/product/product.dart';
import '../repositories/product_repository.dart';

final class GetProducts {
  GetProducts(this._productRepository);
  final ProductRepository _productRepository;

  Future<Either<Failure, ProductsPage>> call({
    required int limit,
    required int skip,
  }) {
    return _productRepository.getProducts(limit: limit, skip: skip);
  }
}