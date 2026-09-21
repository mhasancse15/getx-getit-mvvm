import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getxwithmvvmdemo/presentation/widgets/loading_widget.dart';

import '../controllers/product_controller.dart';
import '../widgets/empty_widget.dart';
import '../widgets/error_widget.dart';

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
                return const LoadingWidget();
              }
              if (controller.products.isEmpty &&
                  controller.errorMessage.value.isNotEmpty) {
                return AppErrorWidget(onRetry: controller.fetchProducts);
              }
              if (controller.filterdProduct.isEmpty) {
                return const EmptyWidget();
              }

              final displayedProducts = controller.filterdProduct;
              return RefreshIndicator(
                onRefresh: controller.refreshProducts,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.pixels >=
                        notification.metrics.maxScrollExtent - 300) {
                      controller.fetchMoreProducts();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: displayedProducts.length + (controller.isLoadingMore.value ? 1 : 0),
                    itemBuilder: (context, int index) {
                      if (index >= displayedProducts.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final product = controller.filterdProduct[index];
                      return ListTile(
                        title: Text(product.title),
                        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
