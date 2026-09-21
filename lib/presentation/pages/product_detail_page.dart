import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/product_details_controller.dart';

class ProductDetailsPage extends GetView<ProductDetailsController> {
  const ProductDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(controller.errorMessage.value),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: controller.retry,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final product = controller.product.value;

        if (product == null) {
          return const Center(
            child: Text('Product not found.'),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.retry,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 1.2,
                    child: Image.network(
                      product.thumbnail,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const ColoredBox(
                          color: Color(0xFFECECEC),
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 56,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  product.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.category.toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Text(
                      '\$${product.discountedPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (product.discountPercentage > 0) ...<Widget>[
                      const SizedBox(width: 10),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(product.rating.toStringAsFixed(1)),
                    const SizedBox(width: 20),
                    Text('${product.stock} items available'),
                  ],
                ),
                const SizedBox(height: 24),
                _DetailsSection(
                  title: 'Description',
                  child: Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                _DetailsSection(
                  title: 'Product information',
                  child: Column(
                    children: <Widget>[
                      _InfoRow(
                        label: 'Brand',
                        value: product.brand ?? 'Not available',
                      ),
                      _InfoRow(
                        label: 'Category',
                        value: product.category,
                      ),
                      _InfoRow(
                        label: 'Stock',
                        value: '${product.stock}',
                      ),
                      _InfoRow(
                        label: 'Rating',
                        value: product.rating.toStringAsFixed(1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _DetailsSection extends StatelessWidget {
  const _DetailsSection({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}