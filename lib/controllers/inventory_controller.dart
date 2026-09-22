import 'dart:async';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/firebase_service.dart';


class InventoryController extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  StreamSubscription<List<ProductModel>>? _productsSubscription;
  StreamSubscription<List<String>>? _categoriesSubscription;

  List<ProductModel> _products = [];
  List<String> _categories = [
    'Exhaust',
    'Filters',
    'Bend Pipes',
    'Crash Guards',
    'Handlebars & Levers',
    'Performance ECU',
    'Brake Systems',
  ];
  String _searchQuery = '';
  String _selectedCategory = 'All Categories';
  bool _isLoading = true;
  String? _errorMessage;

  List<ProductModel> get products => _products;
  List<String> get categories => _categories;
  List<String> get allCategoriesWithAll => ['All Categories', ..._categories];
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  InventoryController() {
    _initProducts();
    _initCategories();
  }

  void _initCategories() {
    _firebaseService.ensureCategoriesInitialized();
    _categoriesSubscription = _firebaseService.getCategoriesStream().listen((categoryList) {
      _categories = categoryList;
      notifyListeners();
    }, onError: (_) {});
  }

  Future<void> addCategory(String categoryName) async {
    final clean = categoryName.trim();
    if (clean.isEmpty) return;
    try {
      await _firebaseService.addCategory(clean);
      if (!_categories.contains(clean)) {
        _categories.add(clean);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to add category to Firebase.';
      notifyListeners();
    }
  }

  Future<void> deleteCategory(String categoryName) async {
    final clean = categoryName.trim();
    if (clean.isEmpty) return;
    try {
      await _firebaseService.deleteCategory(clean);
      _categories.removeWhere((c) => c.toLowerCase() == clean.toLowerCase());
      if (_selectedCategory.toLowerCase() == clean.toLowerCase()) {
        _selectedCategory = 'All Categories';
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to delete category from Firebase.';
      notifyListeners();
    }
  }

  Future<void> _initProducts() async {
    _isLoading = true;
    notifyListeners();

    Timer? safetyTimer = Timer(const Duration(milliseconds: 1500), () {
      if (_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    });

    try {
      _productsSubscription = _firebaseService.getProductsStream().listen((productList) {
        safetyTimer?.cancel();
        safetyTimer = null;
        _products = productList;
        _isLoading = false;
        notifyListeners();
      }, onError: (err) {
        safetyTimer?.cancel();
        safetyTimer = null;
        _errorMessage = 'Failed to sync inventory with Firebase.';
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      safetyTimer?.cancel();
      safetyTimer = null;
      _isLoading = false;
      notifyListeners();
    }
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

  Future<void> addProduct(ProductModel product) async {
    try {
      await _firebaseService.addProduct(product);
    } catch (e) {
      _errorMessage = 'Failed to create product in Firebase.';
      notifyListeners();
    }
  }

  Future<void> updateProduct(ProductModel updatedProduct) async {
    try {
      await _firebaseService.updateProduct(updatedProduct);
    } catch (e) {
      _errorMessage = 'Failed to update product in Firebase.';
      notifyListeners();
    }
  }

  Future<void> updateStock(String productId, int newStock) async {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      final updated = _products[index].copyWith(
        stock: newStock < 0 ? 0 : newStock,
        updatedAt: DateTime.now(),
      );
      await updateProduct(updated);
    }
  }

  Future<void> quickAdjustStock(String productId, int delta) async {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      final currentStock = _products[index].stock;
      final updatedStock = (currentStock + delta) < 0 ? 0 : (currentStock + delta);
      final updated = _products[index].copyWith(
        stock: updatedStock,
        updatedAt: DateTime.now(),
      );
      await updateProduct(updated);
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firebaseService.deleteProduct(productId);
    } catch (e) {
      _errorMessage = 'Failed to delete product from Firebase.';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _productsSubscription?.cancel();
    _categoriesSubscription?.cancel();
    super.dispose();
  }
}
