import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/product/product.dart';
import 'product_model.dart';
part 'products_response_model.freezed.dart';
part 'products_response_model.g.dart';

@freezed
abstract class ProductsResponseModel with _$ProductsResponseModel {
  const factory ProductsResponseModel({
    @Default(<ProductModel>[]) List<ProductModel> products,
    @Default(0) int total,
    @Default(0) int skip,
    @Default(0) int limit,
  }) = _ProductsResponseModel;

  factory ProductsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProductsResponseModelFromJson(json);
}

extension ProductsResponseModelMapper on ProductsResponseModel {
  ProductsPage toEntity() {
    return ProductsPage(
      products: products
          .map((product) => product.toEntity())
          .toList(growable: false),
      total: total,
      skip: skip,
      limit: limit,
    );
  }
}