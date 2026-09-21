

import 'package:get/get.dart';

import '../../core/di/injection.dart';
import '../controllers/product_controller.dart';

final class ProductBinding extends Bindings{
  @override
  void dependencies() {
   if (!Get.isRegistered<ProductController>()) {
     Get.lazyPut<ProductController>(() => getIt<ProductController>());
   }
  }
}