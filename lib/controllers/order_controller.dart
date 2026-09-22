import 'dart:async';
import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/firebase_service.dart';
import '../utils/app_constants.dart';


class OrderController extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  StreamSubscription<List<OrderModel>>? _ordersSubscription;

  List<OrderModel> _orders = [];
  String _selectedStatusFilter = 'All Statuses';
  String _searchQuery = '';
  bool _isLoading = true;
  String? _errorMessage;

  List<OrderModel> get orders => _orders;
  String get selectedStatusFilter => _selectedStatusFilter;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  OrderController() {
    _initOrders();
  }

  Future<void> _initOrders() async {
    _isLoading = true;
    notifyListeners();

    Timer? safetyTimer = Timer(const Duration(milliseconds: 1500), () {
      if (_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    });

    try {
      _ordersSubscription = _firebaseService.getOrdersStream().listen((orderList) {
        safetyTimer?.cancel();
        safetyTimer = null;
        _orders = orderList;
        _isLoading = false;
        notifyListeners();
      }, onError: (err) {
        safetyTimer?.cancel();
        safetyTimer = null;
        _errorMessage = 'Failed to sync orders with Firebase.';
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


  List<OrderModel> get filteredOrders {
    return _orders.where((order) {
      final matchesStatus = _selectedStatusFilter == 'All Statuses' ||
          order.status == _selectedStatusFilter;
      final query = _searchQuery.toLowerCase().trim();
      final matchesSearch = query.isEmpty ||
          order.orderNumber.toLowerCase().contains(query) ||
          order.customerName.toLowerCase().contains(query) ||
          order.customerEmail.toLowerCase().contains(query) ||
          (order.trackingId != null && order.trackingId!.toLowerCase().contains(query));
      return matchesStatus && matchesSearch;
    }).toList();
  }

  int get pendingOrdersCount => _orders.where((o) => o.status == AppConstants.orderStatusPending).length;
  int get activeOrdersCount => _orders.where((o) => o.status == AppConstants.orderStatusPending || o.status == AppConstants.orderStatusAccepted || o.status == AppConstants.orderStatusDispatched).length;
  int get dispatchPendingCount => _orders.where((o) => o.status == AppConstants.orderStatusAccepted).length;

  double get totalSalesAmount {
    return _orders
        .where((o) => o.status != AppConstants.orderStatusRejected)
        .fold(0.0, (sum, o) => sum + o.totalAmount);
  }

  void setStatusFilter(String status) {
    _selectedStatusFilter = status;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> acceptOrder(String orderId) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final now = DateTime.now();
      final logs = List<TrackingLogEntry>.from(_orders[index].trackingLogs)
        ..add(TrackingLogEntry(
          status: AppConstants.orderStatusAccepted,
          description: 'Order accepted by B1 Customs Admin. Preparing for dispatch.',
          timestamp: now,
        ));

      final updated = _orders[index].copyWith(
        status: AppConstants.orderStatusAccepted,
        trackingLogs: logs,
      );
      try {
        await _firebaseService.updateOrder(updated);
      } catch (e) {
        _errorMessage = 'Failed to accept order in Firebase.';
        notifyListeners();
      }
    }
  }

  Future<void> rejectOrder(String orderId, String reason) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final now = DateTime.now();
      final logs = List<TrackingLogEntry>.from(_orders[index].trackingLogs)
        ..add(TrackingLogEntry(
          status: AppConstants.orderStatusRejected,
          description: 'Order rejected. Reason: $reason',
          timestamp: now,
        ));

      final updated = _orders[index].copyWith(
        status: AppConstants.orderStatusRejected,
        rejectionReason: reason,
        trackingLogs: logs,
      );
      try {
        await _firebaseService.updateOrder(updated);
      } catch (e) {
        _errorMessage = 'Failed to reject order in Firebase.';
        notifyListeners();
      }
    }
  }

  Future<void> dispatchOrder(String orderId, String courierPartner, String trackingId) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final now = DateTime.now();
      final logs = List<TrackingLogEntry>.from(_orders[index].trackingLogs)
        ..add(TrackingLogEntry(
          status: AppConstants.orderStatusDispatched,
          description: 'Package handed over to $courierPartner (Tracking AWB: $trackingId)',
          timestamp: now,
        ));

      final updated = _orders[index].copyWith(
        status: AppConstants.orderStatusDispatched,
        courierPartner: courierPartner,
        trackingId: trackingId,
        trackingLogs: logs,
      );
      try {
        await _firebaseService.updateOrder(updated);
      } catch (e) {
        _errorMessage = 'Failed to dispatch order in Firebase.';
        notifyListeners();
      }
    }
  }

  Future<void> markDelivered(String orderId) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final now = DateTime.now();
      final logs = List<TrackingLogEntry>.from(_orders[index].trackingLogs)
        ..add(TrackingLogEntry(
          status: AppConstants.orderStatusDelivered,
          description: 'Item successfully delivered to customer address.',
          timestamp: now,
        ));

      final updated = _orders[index].copyWith(
        status: AppConstants.orderStatusDelivered,
        trackingLogs: logs,
      );
      try {
        await _firebaseService.updateOrder(updated);
      } catch (e) {
        _errorMessage = 'Failed to mark order delivered in Firebase.';
        notifyListeners();
      }
    }
  }

  Future<void> addOrder(OrderModel order) async {
    try {
      await _firebaseService.addOrder(order);
    } catch (e) {
      _errorMessage = 'Failed to create order in Firebase.';
      notifyListeners();
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await _firebaseService.deleteOrder(orderId);
    } catch (e) {
      _errorMessage = 'Failed to delete order from Firebase.';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _ordersSubscription?.cancel();
    super.dispose();
  }
}
