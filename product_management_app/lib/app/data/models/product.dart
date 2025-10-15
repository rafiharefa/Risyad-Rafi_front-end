import 'category.dart';

class Product {
  final int id;
  final String namaBarang;
  final int kategoriId;
  final int stok;
  final String kelompokBarang;
  final double harga;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Category? category;

  Product({
    required this.id,
    required this.namaBarang,
    required this.kategoriId,
    required this.stok,
    required this.kelompokBarang,
    required this.harga,
    required this.createdAt,
    required this.updatedAt,
    this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      namaBarang: json['nama_barang'] as String,
      kategoriId: json['kategori_id'] as int,
      stok: json['stok'] as int,
      kelompokBarang: json['kelompok_barang'] as String,
      harga: _parsePrice(json['harga']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      category: json['category'] != null 
          ? Category.fromJson(json['category'] as Map<String, dynamic>)
          : null,
    );
  }

  // Helper method to parse price from either String or num
  static double _parsePrice(dynamic price) {
    if (price is num) {
      return price.toDouble();
    } else if (price is String) {
      return double.tryParse(price) ?? 0.0;
    } else {
      return 0.0;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_barang': namaBarang,
      'kategori_id': kategoriId,
      'stok': stok,
      'kelompok_barang': kelompokBarang,
      'harga': harga,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (category != null) 'category': category!.toJson(),
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'nama_barang': namaBarang,
      'kategori_id': kategoriId,
      'stok': stok,
      'kelompok_barang': kelompokBarang,
      'harga': harga,
    };
  }

  Product copyWith({
    int? id,
    String? namaBarang,
    int? kategoriId,
    int? stok,
    String? kelompokBarang,
    double? harga,
    DateTime? createdAt,
    DateTime? updatedAt,
    Category? category,
  }) {
    return Product(
      id: id ?? this.id,
      namaBarang: namaBarang ?? this.namaBarang,
      kategoriId: kategoriId ?? this.kategoriId,
      stok: stok ?? this.stok,
      kelompokBarang: kelompokBarang ?? this.kelompokBarang,
      harga: harga ?? this.harga,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, namaBarang: $namaBarang, kategoriId: $kategoriId, stok: $stok, kelompokBarang: $kelompokBarang, harga: $harga}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}