class Category {
  final int id;
  final String namaKategori;

  Category({
    required this.id,
    required this.namaKategori,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      namaKategori: json['nama_kategori'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_kategori': namaKategori,
    };
  }

  @override
  String toString() {
    return 'Category{id: $id, namaKategori: $namaKategori}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          namaKategori == other.namaKategori;

  @override
  int get hashCode => id.hashCode ^ namaKategori.hashCode;
}