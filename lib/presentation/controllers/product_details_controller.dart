import 'package:get/get.dart';

import '../../core/utils/logger.dart';
import '../../domain/entities/product/product.dart';
import '../../domain/usecases/get_products.dart';


class ProductDetailsController extends GetxController {
  ProductDetailsController(this._getProductById);

  final GetProductById _getProductById;

  final Rxn<Product> product = Rxn<Product>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    final productId = int.tryParse(Get.parameters['id'] ?? '');

    if (productId == null) {
      errorMessage.value = 'Invalid product ID.';
      return;
    }

    fetchProduct(productId);
  }

  Future<void> fetchProduct(int productId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _getProductById(productId);
      result.fold(_setError, _appendPage);
    } catch (error) {
      errorMessage.value = 'Unable to load product details.';
    } finally {
      isLoading.value = false;
    }
  }
  void _setError(failure) {
    errorMessage.value = failure.message;
    AppLogger.error('Unable to load products', failure);
  }


  void _appendPage(Product product) {
    this.product.value = product;
    errorMessage.value = '';
  }

  Future<void> retry() async {
    final productId = int.tryParse(Get.parameters['id'] ?? '');

    if (productId != null) {
      await fetchProduct(productId);
    }
  }
}