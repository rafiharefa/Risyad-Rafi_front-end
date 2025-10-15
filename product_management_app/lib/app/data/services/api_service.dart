import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' hide Category;
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/product.dart';
import '../models/paginated_response.dart';

class ApiService {
  // Platform-specific base URL
  static String get baseUrl {
    if (kIsWeb) {
      // For web, use localhost
      return 'http://localhost:3001/api';
    } else if (Platform.isAndroid) {
      // For Android emulator, use 10.0.2.2 to access host machine
      return 'http://10.0.2.2:3001/api';
    } else if (Platform.isIOS) {
      // For iOS simulator, use localhost
      return 'http://localhost:3001/api';
    } else {
      // Default to localhost for other platforms
      return 'http://localhost:3001/api';
    }
  }
  
  // Categories endpoints
  Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading categories: $e');
    }
  }

  Future<Category> createCategory(String namaKategori) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/categories'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'nama_kategori': namaKategori}),
      );

      if (response.statusCode == 201) {
        return Category.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating category: $e');
    }
  }

  // Products endpoints
  Future<PaginatedResponse<Product>> getProducts({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    try {
      String url = '$baseUrl/products?page=$page&limit=$limit';
      if (search != null && search.isNotEmpty) {
        url += '&search=${Uri.encodeComponent(search)}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return PaginatedResponse.fromJson(data, Product.fromJson);
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading products: $e');
    }
  }

  Future<Product> getProduct(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading product: $e');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/search?q=${Uri.encodeComponent(query)}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching products: $e');
    }
  }

  Future<Product> createProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toCreateJson()),
      );

      if (response.statusCode == 201) {
        return Product.fromJson(json.decode(response.body));
      } else {
        final errorBody = json.decode(response.body);
        throw Exception('Failed to create product: ${errorBody['message'] ?? response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating product: $e');
    }
  }

  Future<Product> updateProduct(int id, Product product) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/products/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toCreateJson()),
      );

      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        final errorBody = json.decode(response.body);
        throw Exception('Failed to update product: ${errorBody['message'] ?? response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating product: $e');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/products/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting product: $e');
    }
  }

  Future<void> bulkDeleteProducts(List<int> ids) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/products/bulk'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'ids': ids}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to bulk delete products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error bulk deleting products: $e');
    }
  }
}