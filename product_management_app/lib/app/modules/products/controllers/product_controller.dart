import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/category.dart';
import '../../../data/models/product.dart';
import '../../../data/services/api_service.dart';

class ProductController extends GetxController {
  final ApiService _apiService = ApiService();

  // Observable variables
  final RxList<Product> products = <Product>[].obs;
  final RxList<Category> categories = <Category>[].obs;
  final RxList<Product> selectedProducts = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isSearchMode = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString errorMessage = ''.obs;
  
  // Pagination
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalItems = 0.obs;
  final int itemsPerPage = 10;

  // Form controllers
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    loadInitialData();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Load initial data
  Future<void> loadInitialData() async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      await Future.wait([
        loadProducts(),
        loadCategories(),
      ]);
    } catch (e) {
      errorMessage.value = 'Failed to load data: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Load products with pagination
  Future<void> loadProducts({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      products.clear();
    }

    if (isLoadingMore.value) return;
    
    try {
      if (!refresh && currentPage.value > 1) {
        isLoadingMore.value = true;
      }

      final response = await _apiService.getProducts(
        page: currentPage.value,
        limit: itemsPerPage,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
      );

      if (refresh || currentPage.value == 1) {
        products.assignAll(response.data);
      } else {
        products.addAll(response.data);
      }

      totalPages.value = response.totalPages;
      totalItems.value = response.total;

    } catch (e) {
      errorMessage.value = 'Failed to load products: $e';
    } finally {
      isLoadingMore.value = false;
    }
  }

  // Load categories
  Future<void> loadCategories() async {
    try {
      final result = await _apiService.getCategories();
      categories.assignAll(result);
    } catch (e) {
      errorMessage.value = 'Failed to load categories: $e';
    }
  }

  // Search products
  Future<void> searchProducts(String query) async {
    searchQuery.value = query;
    currentPage.value = 1;
    
    if (query.isEmpty) {
      isSearchMode.value = false;
      await loadProducts(refresh: true);
    } else {
      isSearchMode.value = true;
      await loadProducts(refresh: true);
    }
  }

  // Load more products (pagination)
  Future<void> loadMoreProducts() async {
    if (currentPage.value < totalPages.value && !isLoadingMore.value) {
      currentPage.value++;
      await loadProducts();
    }
  }

  // Refresh products
  Future<void> refreshProducts() async {
    await loadProducts(refresh: true);
  }

  // Get product by ID
  Future<Product?> getProduct(int id) async {
    try {
      return await _apiService.getProduct(id);
    } catch (e) {
      errorMessage.value = 'Failed to get product: $e';
      return null;
    }
  }

  // Create product
  Future<bool> createProduct(Product product) async {
    try {
      isLoading.value = true;
      await _apiService.createProduct(product);
      await refreshProducts();
      Get.snackbar(
        'Success',
        'Product created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to create product: $e';
      Get.snackbar(
        'Error',
        'Failed to create product: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Update product
  Future<bool> updateProduct(int id, Product product) async {
    try {
      isLoading.value = true;
      await _apiService.updateProduct(id, product);
      await refreshProducts();
      Get.snackbar(
        'Success',
        'Product updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to update product: $e';
      Get.snackbar(
        'Error',
        'Failed to update product: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Delete product
  Future<bool> deleteProduct(int id) async {
    try {
      isLoading.value = true;
      await _apiService.deleteProduct(id);
      await refreshProducts();
      Get.snackbar(
        'Success',
        'Product deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to delete product: $e';
      Get.snackbar(
        'Error',
        'Failed to delete product: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Bulk delete products
  Future<bool> bulkDeleteProducts() async {
    if (selectedProducts.isEmpty) {
      Get.snackbar(
        'Warning',
        'No products selected',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    try {
      isLoading.value = true;
      final ids = selectedProducts.map((p) => p.id).toList();
      await _apiService.bulkDeleteProducts(ids);
      selectedProducts.clear();
      await refreshProducts();
      Get.snackbar(
        'Success',
        '${ids.length} products deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to delete products: $e';
      Get.snackbar(
        'Error',
        'Failed to delete products: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Selection methods
  void toggleProductSelection(Product product) {
    if (selectedProducts.contains(product)) {
      selectedProducts.remove(product);
    } else {
      selectedProducts.add(product);
    }
  }

  void selectAllProducts() {
    selectedProducts.assignAll(products);
  }

  void clearSelection() {
    selectedProducts.clear();
  }

  bool isProductSelected(Product product) {
    return selectedProducts.contains(product);
  }

  // Helper getters
  bool get hasMoreProducts => currentPage.value < totalPages.value;
  bool get isSelectionMode => selectedProducts.isNotEmpty;
  int get selectedCount => selectedProducts.length;
}