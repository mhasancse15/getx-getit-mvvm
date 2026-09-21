import 'package:get/get.dart';

import '../../core/di/injection.dart';
import '../controllers/product_controller.dart';
import '../controllers/user_controller.dart';

final class UserBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<UserController>()) {
      Get.lazyPut<UserController>(() => getIt<UserController>());
    }
  }
}
