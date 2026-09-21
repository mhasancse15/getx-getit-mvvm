import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/product/product.dart';
import '../../domain/usecases/get_products.dart';

import 'package:flutter/material.dart';

final class ProductController extends GetxController {
  ProductController(this._getProducts);

  final GetProducts _getProducts;
  final RxList<Product> products = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  int skip = 0;
  final int limit = AppConstants.pageSize;
  int total = 0;
  bool hasMore = true;

  List<Product> get filterdProduct {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return products.toList(growable: false);
    return products
        .where((product) => product.title.toLowerCase().contains(query))
        .toList(growable: false);
  }

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(listener);
    fetchProducts();
  }

  @override
  void onClose() {
    searchController.removeListener(listener);
    searchController.dispose();
    super.onClose();
  }

  void listener() {
    searchQuery.value = searchController.text;
  }

  Future<void> fetchProducts() async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = '';
    skip = 0;
    total = 0;
    hasMore = true;
    products.clear();

    final productResult = await _getProducts(limit: limit, skip: skip);
    productResult.fold(_setError, _appendPage);
    isLoading.value = false;
  }

  Future<void> fetchMoreProducts() async {
    if (isLoading.value || isRefreshing.value || isLoadingMore.value || !hasMore) {
      return;
    }
    isLoadingMore.value = true;
    errorMessage.value = '';

    final productResult = await _getProducts(limit: limit, skip: skip);
    productResult.fold(_setError, _appendPage);
    isLoadingMore.value = false;
  }

  Future<void> refreshProducts() async {
    if (isRefreshing.value) return;
    isRefreshing.value = true;
    errorMessage.value = '';
    skip = 0;
    total = 0;
    hasMore = true;

    final productResult = await _getProducts(limit: limit, skip: skip);
    productResult.fold(_setError, (page) {
      products
        ..clear()
        ..addAll(page.products);
      total = page.total;
      skip = page.products.length;
      hasMore = products.length < total;
    });

  }

  void _appendPage(ProductsPage page) {
    final existingIds = products.map((product) => product.id).toSet();
    products.addAll(page.products.where((product) => !existingIds.contains(product.id)));
    total = page.total;
    skip += page.products.length;
    hasMore = products.length < total && page.products.isNotEmpty;
    errorMessage.value = '';
  }

  void _setError(failure) {
    errorMessage.value = failure.message;
    AppLogger.error('Unable to load products', failure);
  }

}
