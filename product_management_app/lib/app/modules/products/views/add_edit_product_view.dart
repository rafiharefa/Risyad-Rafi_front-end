import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/product.dart';
import '../../../data/models/category.dart';
import '../controllers/product_controller.dart';

class AddEditProductView extends StatefulWidget {
  final bool isEdit;
  final Product? product;

  const AddEditProductView({
    super.key,
    this.isEdit = false,
    this.product,
  });

  @override
  State<AddEditProductView> createState() => _AddEditProductViewState();
}

class _AddEditProductViewState extends State<AddEditProductView> {
  final _formKey = GlobalKey<FormState>();
  final _namaBarangController = TextEditingController();
  final _stokController = TextEditingController();
  final _hargaController = TextEditingController();

  Category? _selectedCategory;
  String? _selectedKelompokBarang;

  final List<String> _kelompokBarangOptions = [
    'Premium',
    'Regular',
    'Basic',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.product != null) {
      _initializeFormWithProduct();
    }
  }

  void _initializeFormWithProduct() {
    final product = widget.product!;
    _namaBarangController.text = product.namaBarang;
    _stokController.text = product.stok.toString();
    
    // Format price with commas for display
    final formatter = NumberFormat('#,###');
    final priceAsInt = product.harga.toInt();
    _hargaController.text = formatter.format(priceAsInt);
    
    _selectedCategory = product.category;
    _selectedKelompokBarang = product.kelompokBarang;
  }

  @override
  void dispose() {
    _namaBarangController.dispose();
    _stokController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.find<ProductController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.isEdit ? 'Edit Barang' : 'Tambah Barang',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Nama Barang
                    _buildInputField(
                      controller: _namaBarangController,
                      label: 'Nama Barang',
                      hint: 'Masukkan nama barang',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama barang tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Kategori
                    Obx(() => _buildDropdownField<Category>(
                      value: _selectedCategory,
                      label: 'Kategori',
                      hint: 'Pilih kategori',
                      items: controller.categories
                          .map((category) => DropdownMenuItem<Category>(
                                value: category,
                                child: Text(category.namaKategori),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Kategori harus dipilih';
                        }
                        return null;
                      },
                    )),
                    const SizedBox(height: 16),

                    // Kelompok Barang
                    _buildDropdownField<String>(
                      value: _selectedKelompokBarang,
                      label: 'Kelompok Barang',
                      hint: 'Pilih kelompok barang',
                      items: _kelompokBarangOptions
                          .map((kelompok) => DropdownMenuItem<String>(
                                value: kelompok,
                                child: Text(kelompok),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedKelompokBarang = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kelompok barang harus dipilih';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Stok
                    _buildInputField(
                      controller: _stokController,
                      label: 'Stok',
                      hint: 'Masukkan jumlah stok',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Stok tidak boleh kosong';
                        }
                        if (int.tryParse(value) == null || int.parse(value) < 0) {
                          return 'Stok harus berupa angka positif';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Harga
                    _buildInputField(
                      controller: _hargaController,
                      label: 'Harga',
                      hint: 'Masukkan harga barang',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                      ],
                      prefix: const Text('Rp '),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harga tidak boleh kosong';
                        }
                        // Remove commas and other formatting before parsing
                        final cleanValue = value.replaceAll(',', '').replaceAll('.', '');
                        final numericValue = double.tryParse(cleanValue);
                        if (numericValue == null || numericValue <= 0) {
                          return 'Harga harus berupa angka positif';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        // Format currency as user types
                        if (value.isNotEmpty) {
                          final formatter = NumberFormat('#,###');
                          final number = int.tryParse(value.replaceAll(',', ''));
                          if (number != null) {
                            final formatted = formatter.format(number);
                            if (formatted != value) {
                              _hargaController.value = TextEditingValue(
                                text: formatted,
                                selection: TextSelection.collapsed(
                                  offset: formatted.length,
                                ),
                              );
                            }
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Submit button
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          widget.isEdit ? 'Update Barang' : 'Simpan Barang',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    Widget? prefix,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefix != null ? Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: prefix,
            ) : null,
            prefixIconConstraints: prefix != null ? const BoxConstraints(minWidth: 0) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>({
    required T? value,
    required String label,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    String? Function(T?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final controller = Get.find<ProductController>();
    
    // Parse the price (remove commas)
    final hargaText = _hargaController.text.replaceAll(',', '');
    final harga = double.tryParse(hargaText) ?? 0;

    final product = Product(
      id: widget.product?.id ?? 0,
      namaBarang: _namaBarangController.text,
      kategoriId: _selectedCategory!.id,
      stok: int.parse(_stokController.text),
      kelompokBarang: _selectedKelompokBarang!,
      harga: harga,
      createdAt: widget.product?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      category: _selectedCategory,
    );

    bool success;
    if (widget.isEdit) {
      success = await controller.updateProduct(widget.product!.id, product);
    } else {
      success = await controller.createProduct(product);
    }

    if (success) {
      // Small delay to allow snackbar to show and state to settle
      await Future.delayed(const Duration(milliseconds: 500));
      // Close the form and return to previous screen
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}