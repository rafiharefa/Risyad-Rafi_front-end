import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../widgets/product_detail_bottom_sheet.dart';
import '../widgets/product_list_item.dart';
import 'add_edit_product_view.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.find<ProductController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Stok Barang',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Obx(() => controller.isSelectionMode
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.black87),
                  onPressed: controller.clearSelection,
                )
              : IconButton(
                  icon: const Icon(Icons.search, color: Colors.black87),
                  onPressed: () => _showSearchDialog(context, controller),
                )),
        ],
      ),
      body: Column(
        children: [
          // Search bar (when in search mode)
          Obx(() => controller.isSearchMode.value
              ? Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: TextField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          controller.searchController.clear();
                          controller.searchProducts('');
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    onChanged: controller.searchProducts,
                  ),
                )
              : const SizedBox.shrink()),

          // List header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                Obx(() => controller.isSelectionMode
                    ? Checkbox(
                        value: controller.selectedCount == controller.products.length,
                        onChanged: (value) {
                          if (value == true) {
                            controller.selectAllProducts();
                          } else {
                            controller.clearSelection();
                          }
                        },
                      )
                    : const SizedBox.shrink()),
                Expanded(
                  child: Text(
                    'Daftar Produk',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                Obx(() => Text(
                      '${controller.totalItems} items',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    )),
              ],
            ),
          ),

          // Product list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.products.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error Loading Products',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          controller.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: controller.refreshProducts,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (controller.products.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No products found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add your first product',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshProducts,
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: controller.products.length + 
                      (controller.hasMoreProducts ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.products.length) {
                      // Load more indicator
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Obx(() => controller.isLoadingMore.value
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: controller.loadMoreProducts,
                                  child: const Text('Load More'),
                                )),
                        ),
                      );
                    }

                    final product = controller.products[index];
                    return ProductListItem(
                      product: product,
                      isSelected: controller.isProductSelected(product),
                      isSelectionMode: controller.isSelectionMode,
                      onTap: () => _showProductDetail(context, product),
                      onLongPress: () => controller.toggleProductSelection(product),
                      onSelectionChanged: (selected) {
                        if (selected) {
                          controller.toggleProductSelection(product);
                        }
                      },
                    );
                  },
                ),
              );
            }),
          ),

          // Bottom action bar
          Obx(() => controller.isSelectionMode
              ? Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Checkbox(
                        value: false,
                        onChanged: (value) {},
                      ),
                      Text(
                        '${controller.selectedCount} selected',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => _showDeleteConfirmation(context, controller),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
      floatingActionButton: Obx(() => controller.isSelectionMode
          ? const SizedBox.shrink()
          : FloatingActionButton(
              onPressed: () => Get.to(() => const AddEditProductView()),
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add, color: Colors.white),
            )),
    );
  }

  void _showSearchDialog(BuildContext context, ProductController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Products'),
        content: TextField(
          controller: controller.searchController,
          decoration: const InputDecoration(
            hintText: 'Enter product name...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          onSubmitted: (value) {
            controller.searchProducts(value);
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.searchProducts(controller.searchController.text);
              Navigator.of(context).pop();
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showProductDetail(BuildContext context, product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductDetailBottomSheet(product: product),
    );
  }

  void _showDeleteConfirmation(BuildContext context, ProductController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Products'),
        content: Text(
          'Are you sure you want to delete ${controller.selectedCount} selected products?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              await controller.bulkDeleteProducts();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}