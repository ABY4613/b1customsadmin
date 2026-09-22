import 'package:flutter/material.dart';
import '../../controllers/inventory_controller.dart';
import '../../models/product_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_image.dart';
import '../../widgets/product_modal.dart';
import '../../widgets/status_badge.dart';

class InventoryView extends StatefulWidget {
  final InventoryController inventoryController;

  const InventoryView({
    super.key,
    required this.inventoryController,
  });

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddProductModal() {
    showDialog(
      context: context,
      builder: (context) => ProductModal(
        availableCategories: widget.inventoryController.allCategoriesWithAll,
        onAddCategory: (catName) {
          widget.inventoryController.addCategory(catName);
        },
        onSave: (product) {
          widget.inventoryController.addProduct(product);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Created product "${product.title}" (${product.sku})'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  void _openEditProductModal(ProductModel product) {
    showDialog(
      context: context,
      builder: (context) => ProductModal(
        existingProduct: product,
        availableCategories: widget.inventoryController.allCategoriesWithAll,
        onAddCategory: (catName) {
          widget.inventoryController.addCategory(catName);
        },
        onSave: (updated) {
          widget.inventoryController.updateProduct(updated);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Updated product "${updated.title}"'),
              backgroundColor: AppColors.info,
            ),
          );
        },
      ),
    );
  }

  void _openAddCategoryDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceLight,
        title: const Row(
          children: [
            Icon(Icons.category, color: AppColors.primary),
            SizedBox(width: 8),
            Text('ADD NEW CATEGORY TO FIREBASE'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter category name to create in Cloud Firestore:',
              style: TextStyle(color: AppColors.accentGrey, fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autofocus: true,
              style: const TextStyle(color: AppColors.accentWhite),
              decoration: const InputDecoration(
                hintText: 'e.g. Suspension, Lighting, Helmets, Lubricants...',
              ),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final val = controller.text.trim();
              if (val.isNotEmpty) {
                widget.inventoryController.addCategory(val);
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Category "$val" added to Firebase!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: const Text('Add Category'),
          ),
        ],
      ),
    );
  }

  void _openManageCategoriesDialog() {
    final addController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return ListenableBuilder(
          listenable: widget.inventoryController,
          builder: (context, _) {
            final categories = widget.inventoryController.categories;
            return AlertDialog(
              backgroundColor: AppColors.surfaceLight,
              title: const Row(
                children: [
                  Icon(Icons.tune, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text('MANAGE & DELETE CATEGORIES'),
                ],
              ),
              content: SizedBox(
                width: 450,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add new categories or delete existing categories from Firebase Firestore:',
                      style: TextStyle(color: AppColors.accentGrey, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: addController,
                            style: const TextStyle(color: AppColors.accentWhite, fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: 'New category name...',
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            final val = addController.text.trim();
                            if (val.isNotEmpty) {
                              widget.inventoryController.addCategory(val);
                              addController.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Category "$val" added to Firebase!'),
                                  backgroundColor: AppColors.success,
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Add'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    const Text(
                      'EXISTING CATEGORIES:',
                      style: TextStyle(
                        color: AppColors.accentWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 250),
                      child: categories.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'No custom categories found.',
                                style: TextStyle(color: AppColors.accentGrey),
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              itemCount: categories.length,
                              separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.border),
                              itemBuilder: (context, index) {
                                final cat = categories[index];
                                return ListTile(
                                  dense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                  title: Text(
                                    cat,
                                    style: const TextStyle(
                                      color: AppColors.accentWhite,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline, color: AppColors.danger, size: 20),
                                    onPressed: () {
                                      _confirmDeleteCategory(cat);
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              actions: [
                OutlinedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDeleteCategory(String categoryName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceLight,
        title: const Row(
          children: [
            Icon(Icons.delete_forever, color: AppColors.danger),
            SizedBox(width: 8),
            Text('DELETE CATEGORY'),
          ],
        ),
        content: Text(
          'Are you sure you want to permanently delete category "$categoryName" from Firebase?',
          style: const TextStyle(color: AppColors.accentWhite),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () {
              widget.inventoryController.deleteCategory(categoryName);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deleted category "$categoryName" from Firebase!'),
                  backgroundColor: AppColors.danger,
                ),
              );
            },
            child: const Text('Delete Category'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(ProductModel product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceLight,
        title: const Row(
          children: [
            Icon(Icons.delete_forever, color: AppColors.danger),
            SizedBox(width: 8),
            Text('DELETE PRODUCT'),
          ],
        ),
        content: Text(
          'Are you sure you want to permanently delete "${product.title}" (${product.sku})?',
          style: const TextStyle(color: AppColors.accentWhite),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () {
              widget.inventoryController.deleteProduct(product.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deleted product "${product.title}"'),
                  backgroundColor: AppColors.danger,
                ),
              );
            },
            child: const Text('Delete Product'),
          ),
        ],
      ),
    );
  }

  void _showQuickStockDialog(ProductModel product) {
    final controller = TextEditingController(text: product.stock.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceLight,
        title: Text('QUICK STOCK ADJUSTMENT - ${product.sku}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product: ${product.title}', style: const TextStyle(color: AppColors.accentGrey, fontSize: 13)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: const TextStyle(color: AppColors.accentWhite, fontSize: 18, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                labelText: 'New Stock Count',
                suffixIcon: Icon(Icons.inventory, color: AppColors.primary),
              ),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newStock = int.tryParse(controller.text.trim());
              if (newStock != null) {
                widget.inventoryController.updateStock(product.id, newStock);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Update Stock'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.inventoryController,
      builder: (context, _) {
        final products = widget.inventoryController.filteredProducts;
        final selectedCategory = widget.inventoryController.selectedCategory;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ACCESSORY INVENTORY & STOCK CONTROL',
                        style: TextStyle(
                          color: AppColors.accentWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        '${products.length} products listed under ${selectedCategory == "All Categories" ? "all categories" : selectedCategory}',
                        style: const TextStyle(color: AppColors.accentGrey, fontSize: 12),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: _openAddProductModal,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add New Product'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Search & Category Tabs Bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) => widget.inventoryController.setSearchQuery(val),
                            style: const TextStyle(color: AppColors.accentWhite, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Search by title, SKU, or category...',
                              prefixIcon: const Icon(Icons.search, color: AppColors.accentGrey),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, color: AppColors.accentGrey),
                                      onPressed: () {
                                        _searchController.clear();
                                        widget.inventoryController.setSearchQuery('');
                                      },
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Category Filter Scrollable Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...widget.inventoryController.allCategoriesWithAll.map((category) {
                            final isSelected = selectedCategory == category;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                selected: isSelected,
                                label: Text(category),
                                labelStyle: TextStyle(
                                  color: isSelected ? AppColors.background : AppColors.accentWhite,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  fontSize: 12,
                                ),
                                selectedColor: AppColors.primary,
                                backgroundColor: AppColors.surfaceLight,
                                side: BorderSide(
                                  color: isSelected ? AppColors.primary : AppColors.border,
                                ),
                                onSelected: (_) {
                                  widget.inventoryController.setSelectedCategory(category);
                                },
                              ),
                            );
                          }),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: ActionChip(
                              avatar: const Icon(Icons.add, size: 16, color: AppColors.primary),
                              label: const Text('+ Add Category',
                                  style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                              backgroundColor: AppColors.primary.withOpacity(0.12),
                              side: const BorderSide(color: AppColors.primary),
                              onPressed: _openAddCategoryDialog,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: ActionChip(
                              avatar: const Icon(Icons.delete_sweep, size: 16, color: AppColors.danger),
                              label: const Text('Manage & Delete',
                                  style: TextStyle(
                                      color: AppColors.danger,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                              backgroundColor: AppColors.danger.withOpacity(0.12),
                              side: const BorderSide(color: AppColors.danger),
                              onPressed: _openManageCategoriesDialog,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Inventory Data Table Container
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: products.isEmpty
                    ? Container(
                        padding: const EdgeInsets.all(40),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            const Icon(Icons.inventory_2_outlined, color: AppColors.textMuted, size: 48),
                            const SizedBox(height: 12),
                            const Text(
                              'No products found matching your filter criteria.',
                              style: TextStyle(color: AppColors.accentGrey, fontSize: 14),
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton(
                              onPressed: () {
                                _searchController.clear();
                                widget.inventoryController.setSearchQuery('');
                                widget.inventoryController.setSelectedCategory('All Categories');
                              },
                              child: const Text('Reset Search Filters'),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 24,
                          headingRowColor: WidgetStateProperty.all(AppColors.surfaceLight),
                          dataRowMaxHeight: 68,
                          columns: const [
                            DataColumn(label: Text('PRODUCT & SKU', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('CATEGORY', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('UNIT PRICE', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('STOCK COUNT', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('STOCK STATUS', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: products.map((product) {
                            String stockStatusText = 'In Stock';
                            if (product.isOutOfStock) {
                              stockStatusText = 'Out of Stock';
                            } else if (product.isLowStock) {
                              stockStatusText = 'Low Stock';
                            }

                            return DataRow(
                              cells: [
                                // Title & Image & SKU
                                DataCell(
                                  Row(
                                    children: [
                                      AppImage(
                                        imageUrl: product.imageUrl,
                                        width: 44,
                                        height: 44,
                                        borderRadius: BorderRadius.circular(8),
                                        fallbackIcon: Icons.two_wheeler,
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.title,
                                            style: const TextStyle(
                                              color: AppColors.accentWhite,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text(
                                            'SKU: ${product.sku}',
                                            style: const TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Category
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceLight,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: AppColors.border),
                                    ),
                                    child: Text(
                                      product.category,
                                      style: const TextStyle(color: AppColors.accentWhite, fontSize: 11),
                                    ),
                                  ),
                                ),
                                // Price
                                DataCell(
                                  Text(
                                    AppFormatters.formatCurrency(product.price),
                                    style: const TextStyle(
                                      color: AppColors.accentWhite,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                // Stock Count & Quick Adjuster
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline, size: 18, color: AppColors.accentGrey),
                                        onPressed: () {
                                          widget.inventoryController.quickAdjustStock(product.id, -1);
                                        },
                                        tooltip: 'Decrease 1',
                                      ),
                                      InkWell(
                                        onTap: () => _showQuickStockDialog(product),
                                        borderRadius: BorderRadius.circular(6),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: product.isLowStock || product.isOutOfStock
                                                ? AppColors.warning.withOpacity(0.2)
                                                : AppColors.surfaceLight,
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(
                                              color: product.isLowStock
                                                  ? AppColors.warning
                                                  : product.isOutOfStock
                                                      ? AppColors.danger
                                                      : AppColors.borderHighlight,
                                            ),
                                          ),
                                          child: Text(
                                            '${product.stock}',
                                            style: TextStyle(
                                              color: product.isOutOfStock
                                                  ? AppColors.danger
                                                  : product.isLowStock
                                                      ? AppColors.warning
                                                      : AppColors.accentWhite,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle_outline, size: 18, color: AppColors.primary),
                                        onPressed: () {
                                          widget.inventoryController.quickAdjustStock(product.id, 1);
                                        },
                                        tooltip: 'Increase 1',
                                      ),
                                    ],
                                  ),
                                ),
                                // Status Badge
                                DataCell(
                                  StatusBadge(
                                    status: stockStatusText,
                                    isStockStatus: true,
                                  ),
                                ),
                                // Edit & Delete Actions
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 18),
                                        onPressed: () => _openEditProductModal(product),
                                        tooltip: 'Edit Details',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, color: AppColors.danger, size: 18),
                                        onPressed: () => _confirmDelete(product),
                                        tooltip: 'Delete Product',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
