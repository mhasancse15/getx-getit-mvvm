import 'package:flutter/material.dart';
import 'package:getxwithmvvmdemo/presentation/widgets/product_view.dart';

import '../../domain/entities/product/product.dart';

class ProductGridView extends StatelessWidget {
  const ProductGridView({
    required this.products,
    this.onProductTap,
    super.key,
  });

  final List<Product> products;
  final ValueChanged<Product>? onProductTap;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Text('No products found.'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 240,
        mainAxisExtent: 325,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final product = products[index];

        return ProductCard(
          product: product,
          onTap: onProductTap == null
              ? null
              : () => onProductTap!(product),
        );
      },
    );
  }
}