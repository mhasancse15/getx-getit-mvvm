import 'package:get/get.dart';

import '../../presentation/bindings/product_binding.dart';
import '../../presentation/bindings/product_details_binding.dart';
import '../../presentation/bindings/user_binding.dart';
import '../../presentation/pages/product_detail_page.dart';
import '../../presentation/pages/product_list_page.dart';
import '../../presentation/pages/user_details_page.dart';
import '../../presentation/pages/user_list_page.dart';
import 'app_routes.dart';

abstract final class AppPages {
  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.users,
      page: () => const UserListPage(),
      binding: UserBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.userDetails,
      page: () => const UserDetailsPage(),
      binding: UserBinding(),
    ),

    GetPage<dynamic>(
      name: AppRoutes.products,
      page: () => const ProductListPage(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: AppRoutes.productDetails,
      page: () => const ProductDetailsPage(),
      binding: ProductDetailsBinding(),
    ),
  ];
}
