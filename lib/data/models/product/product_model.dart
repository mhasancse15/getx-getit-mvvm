import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/product/product.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
abstract class ProductModel with _$ProductModel {
  const factory ProductModel({
    required int id,
    @Default('') String title,
    @Default('') String description,
    @Default('') String category,
    @Default(0) double price,
    @Default(0) double discountPercentage,
    @Default(0) double rating,
    @Default(0) int stock,
    String? brand,
    @Default('') String thumbnail,
    @Default(<String>[]) List<String> images,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}

extension ProductModelMapper on ProductModel {
  Product toEntity() {
    return Product(
      id: id,
      title: title,
      description: description,
      category: category,
      price: price,
      discountPercentage: discountPercentage,
      rating: rating,
      stock: stock,
      brand: brand,
      thumbnail: thumbnail,
      images: List.unmodifiable(images),
    );
  }
}