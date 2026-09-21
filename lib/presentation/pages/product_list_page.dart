import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/product_controller.dart';

class ProductListPage extends GetView<ProductController> {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products'), centerTitle: false),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: controller.searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search by product title',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: Obx(
                  () => controller.searchQuery.value.isEmpty
                      ? const SizedBox.shrink()
                      : IconButton(
                          onPressed: controller.searchController.clear,
                          icon: const Icon(Icons.clear_rounded),
                        ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.products.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.products.isEmpty &&
                  controller.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(controller.errorMessage.value),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: controller.fetchProducts,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              if (controller.filterdProduct.isEmpty) {
                return const Center(child: Text('No products found.'));
              }
              return ListView.builder(
                itemCount: controller.filterdProduct.length,
                itemBuilder: (BuildContext context, int index) {
                  final product = controller.filterdProduct[index];
                  return ListTile(
                    title: Text(product.title),
                    subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
