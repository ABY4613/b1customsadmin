import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/mock_data_service.dart';

class InventoryController extends ChangeNotifier {
  List<ProductModel> _products = [];
  String _searchQuery = '';
  String _selectedCategory = 'All Categories';
  final bool _isLoading = false;

  List<ProductModel> get products => _products;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  InventoryController() {
    _products = MockDataService.getInitialProducts();
  }

  List<ProductModel> get filteredProducts {
    return _products.where((product) {
      final matchesCategory = _selectedCategory == 'All Categories' ||
          product.category == _selectedCategory;
      final query = _searchQuery.toLowerCase().trim();
      final matchesSearch = query.isEmpty ||
          product.title.toLowerCase().contains(query) ||
          product.sku.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<ProductModel> get lowStockProducts {
    return _products.where((p) => p.isLowStock || p.isOutOfStock).toList();
  }

  int get lowStockCount => lowStockProducts.length;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void addProduct(ProductModel product) {
    _products.insert(0, product);
    notifyListeners();
  }

  void updateProduct(ProductModel updatedProduct) {
    final index = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners();
    }
  }

  void updateStock(String productId, int newStock) {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      _products[index] = _products[index].copyWith(
        stock: newStock < 0 ? 0 : newStock,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void quickAdjustStock(String productId, int delta) {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      final currentStock = _products[index].stock;
      final updatedStock = (currentStock + delta) < 0 ? 0 : (currentStock + delta);
      _products[index] = _products[index].copyWith(
        stock: updatedStock,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void deleteProduct(String productId) {
    _products.removeWhere((p) => p.id == productId);
    notifyListeners();
  }
}
