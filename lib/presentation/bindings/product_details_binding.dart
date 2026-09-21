import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../../core/di/injection.dart';
import '../../domain/usecases/get_products.dart';
import '../controllers/product_details_controller.dart';

class ProductDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GetProductById>(
          () => GetProductById(getIt()),
    );

    Get.lazyPut<ProductDetailsController>(
          () => ProductDetailsController(Get.find<GetProductById>()),
    );
  }
}