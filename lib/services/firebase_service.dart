import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

class FirebaseService {
  FirebaseFirestore? get _db {
    try {
      return FirebaseFirestore.instance;
    } catch (_) {
      return null;
    }
  }

  CollectionReference<Map<String, dynamic>>? get _productsRef => _db?.collection('products');
  CollectionReference<Map<String, dynamic>>? get _ordersRef => _db?.collection('orders');
  CollectionReference<Map<String, dynamic>>? get _usersRef => _db?.collection('users');
  CollectionReference<Map<String, dynamic>>? get _categoriesRef => _db?.collection('categories');

  /// Seed initial products and orders if collections are empty in Firestore (Disabled to prevent dummy data)
  Future<void> seedInitialDataIfEmpty() async {
    // Disabled - Users manage real items directly via Cloud Firestore
  }

  static const List<String> _defaultCategories = [
    'Exhaust',
    'Filters',
    'Bend Pipes',
    'Crash Guards',
    'Handlebars & Levers',
    'Performance ECU',
    'Brake Systems',
  ];

  Future<void> ensureCategoriesInitialized() async {
    final categoriesRef = _categoriesRef;
    if (categoriesRef == null) return;
    try {
      final snap = await categoriesRef.get();
      if (snap.docs.isEmpty) {
        for (final cat in _defaultCategories) {
          await categoriesRef.doc(cat).set({
            'name': cat,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (_) {}
  }

  // --- CATEGORIES ---
  Stream<List<String>> getCategoriesStream() {
    final categoriesRef = _categoriesRef;
    if (categoriesRef == null) {
      return Stream.value(_defaultCategories);
    }

    return categoriesRef.snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return _defaultCategories;
      }
      final list = snapshot.docs
          .map((doc) => doc.data()['name']?.toString() ?? doc.id)
          .where((name) => name.trim().isNotEmpty)
          .toList();
      return list.isEmpty ? _defaultCategories : list;
    });
  }

  Future<void> addCategory(String categoryName) async {
    final categoriesRef = _categoriesRef;
    if (categoriesRef == null) return;
    final cleanName = categoryName.trim();
    if (cleanName.isEmpty) return;
    await ensureCategoriesInitialized();
    final docRef = categoriesRef.doc(cleanName);
    await docRef.set({
      'name': cleanName,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> deleteCategory(String categoryName) async {
    final categoriesRef = _categoriesRef;
    if (categoriesRef == null) return;
    final cleanName = categoryName.trim();
    if (cleanName.isEmpty) return;
    await ensureCategoriesInitialized();
    await categoriesRef.doc(cleanName).delete();
  }

  // --- PRODUCTS ---
  Stream<List<ProductModel>> getProductsStream() {
    final productsRef = _productsRef;
    if (productsRef == null) {
      return Stream.value([]);
    }
    return productsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ProductModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  Future<void> addProduct(ProductModel product) async {
    final productsRef = _productsRef;
    if (productsRef == null) return;
    final docRef = productsRef.doc(product.id.isNotEmpty ? product.id : null);
    final pWithId = product.id.isNotEmpty ? product : product.copyWith(id: docRef.id);
    await docRef.set(pWithId.toJson(), SetOptions(merge: true));
  }

  Future<void> updateProduct(ProductModel product) async {
    final productsRef = _productsRef;
    if (productsRef == null) return;
    await productsRef.doc(product.id).set(product.toJson(), SetOptions(merge: true));
  }

  Future<void> deleteProduct(String productId) async {
    final productsRef = _productsRef;
    if (productsRef == null) return;
    await productsRef.doc(productId).delete();
  }

  // --- ORDERS ---
  Stream<List<OrderModel>> getOrdersStream() {
    final ordersRef = _ordersRef;
    if (ordersRef == null) {
      return Stream.value([]);
    }
    return ordersRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => OrderModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  Future<void> addOrder(OrderModel order) async {
    final ordersRef = _ordersRef;
    if (ordersRef == null) return;
    final docRef = ordersRef.doc(order.id.isNotEmpty ? order.id : null);
    final oWithId = order.id.isNotEmpty ? order : order.copyWith(id: docRef.id);
    await docRef.set(oWithId.toJson(), SetOptions(merge: true));
  }

  Future<void> updateOrder(OrderModel order) async {
    final ordersRef = _ordersRef;
    if (ordersRef == null) return;
    await ordersRef.doc(order.id).update(order.toJson());
  }

  Future<void> deleteOrder(String orderId) async {
    final ordersRef = _ordersRef;
    if (ordersRef == null) return;
    await ordersRef.doc(orderId).delete();
  }

  // --- USERS ---
  Future<void> saveUserProfile(UserModel user) async {
    final usersRef = _usersRef;
    if (usersRef == null) return;
    await usersRef.doc(user.id).set(user.toJson(), SetOptions(merge: true));
  }

  Future<UserModel?> getUserProfile(String uid) async {
    final usersRef = _usersRef;
    if (usersRef == null) return null;
    try {
      final doc = await usersRef.doc(uid).get().timeout(const Duration(seconds: 2));
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!, doc.id);
      }
    } catch (_) {}
    return null;
  }
}
