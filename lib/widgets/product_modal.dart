import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/formatters.dart';
import 'custom_text_field.dart';

class ProductModal extends StatefulWidget {
  final ProductModel? existingProduct;
  final Function(ProductModel) onSave;

  const ProductModal({
    super.key,
    this.existingProduct,
    required this.onSave,
  });

  @override
  State<ProductModal> createState() => _ProductModalState();
}

class _ProductModalState extends State<ProductModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _skuController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;
  String _selectedCategory = 'Exhaust';

  @override
  void initState() {
    super.initState();
    final p = widget.existingProduct;
    _titleController = TextEditingController(text: p?.title ?? '');
    _skuController = TextEditingController(text: p?.sku ?? '');
    _priceController = TextEditingController(text: p != null ? p.price.toStringAsFixed(0) : '');
    _stockController = TextEditingController(text: p != null ? p.stock.toString() : '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _imageUrlController = TextEditingController(
      text: p?.imageUrl ??
          'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=500&auto=format&fit=crop&q=60',
    );
    if (p != null && AppConstants.productCategories.contains(p.category)) {
      _selectedCategory = p.category;
    } else {
      _selectedCategory = AppConstants.productCategories[1]; // 'Exhaust'
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _skuController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _generateSku() {
    if (_titleController.text.isNotEmpty) {
      final generated = AppFormatters.generateSku(_selectedCategory, _titleController.text);
      setState(() {
        _skuController.text = generated;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final isEdit = widget.existingProduct != null;
      final now = DateTime.now();

      final newProduct = ProductModel(
        id: isEdit ? widget.existingProduct!.id : 'prod_${now.millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        sku: _skuController.text.trim(),
        category: _selectedCategory,
        price: double.tryParse(_priceController.text.trim()) ?? 0.0,
        stock: int.tryParse(_stockController.text.trim()) ?? 0,
        description: _descriptionController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        createdAt: isEdit ? widget.existingProduct!.createdAt : now,
        updatedAt: now,
      );

      widget.onSave(newProduct);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingProduct != null;

    return Dialog(
      backgroundColor: AppColors.surfaceLight,
      surfaceTintColor: Colors.transparent,
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modal Title Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isEdit ? Icons.edit : Icons.add_box,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isEdit ? 'EDIT ACCESSORY PRODUCT' : 'ADD NEW ACCESSORY PRODUCT',
                      style: const TextStyle(
                        color: AppColors.accentWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.accentGrey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(height: 24),
            // Form Body
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        label: 'Product Title *',
                        hint: 'e.g. B1 Stealth Titanium Exhaust',
                        controller: _titleController,
                        onChanged: (val) {
                          if (!isEdit && _skuController.text.isEmpty) {
                            _generateSku();
                          }
                        },
                        validator: (val) =>
                            val == null || val.trim().isEmpty ? 'Title is required' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Category *',
                                  style: TextStyle(
                                    color: AppColors.accentWhite,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedCategory,
                                      isExpanded: true,
                                      dropdownColor: AppColors.surfaceLight,
                                      style: const TextStyle(
                                        color: AppColors.accentWhite,
                                        fontSize: 14,
                                      ),
                                      items: AppConstants.productCategories
                                          .where((c) => c != 'All Categories')
                                          .map((c) => DropdownMenuItem(
                                                value: c,
                                                child: Text(c),
                                              ))
                                          .toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          setState(() {
                                            _selectedCategory = val;
                                          });
                                          if (!isEdit) _generateSku();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Stack(
                              children: [
                                CustomTextField(
                                  label: 'Stock Keeping Unit (SKU) *',
                                  hint: 'B1-EX-TT-001',
                                  controller: _skuController,
                                  validator: (val) =>
                                      val == null || val.trim().isEmpty ? 'SKU required' : null,
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: TextButton(
                                    onPressed: _generateSku,
                                    child: const Text(
                                      'Auto-Gen',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: 'Price (₹ INR) *',
                              hint: '34999',
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) return 'Price required';
                                if (double.tryParse(val) == null) return 'Must be a number';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomTextField(
                              label: 'Initial Stock Count *',
                              hint: '15',
                              controller: _stockController,
                              keyboardType: TextInputType.number,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) return 'Stock required';
                                if (int.tryParse(val) == null) return 'Must be integer';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Description',
                        hint: 'Technical specifications, material grade, and fitment details...',
                        controller: _descriptionController,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Product Image URL / Asset Trigger',
                        hint: 'https://images.unsplash.com/...',
                        controller: _imageUrlController,
                        prefixIcon: const Icon(Icons.image_outlined, color: AppColors.accentGrey),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Mock Image Picker triggered: Image uploaded successfully.'),
                              backgroundColor: AppColors.info,
                            ),
                          );
                        },
                        icon: const Icon(Icons.cloud_upload_outlined, size: 18),
                        label: const Text('Upload Local Image File'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(height: 24),
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.check, size: 18),
                  label: Text(isEdit ? 'Save Changes' : 'Create Product'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
