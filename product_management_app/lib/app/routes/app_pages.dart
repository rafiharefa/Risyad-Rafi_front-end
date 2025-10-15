import 'package:get/get.dart';
import '../modules/products/views/product_list_view.dart';
import '../modules/products/views/add_edit_product_view.dart';
import '../modules/products/controllers/product_controller.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const ProductListView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ProductController>(() => ProductController());
      }),
    ),
    GetPage(
      name: AppRoutes.productList,
      page: () => const ProductListView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ProductController>(() => ProductController());
      }),
    ),
    GetPage(
      name: AppRoutes.addProduct,
      page: () => const AddEditProductView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ProductController>(() => ProductController());
      }),
    ),
    GetPage(
      name: AppRoutes.editProduct,
      page: () => const AddEditProductView(isEdit: true),
      binding: BindingsBuilder(() {
        Get.lazyPut<ProductController>(() => ProductController());
      }),
    ),
  ];
}