import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/mock_data_service.dart';
import '../utils/app_constants.dart';

class OrderController extends ChangeNotifier {
  List<OrderModel> _orders = [];
  String _selectedStatusFilter = 'All Statuses';
  String _searchQuery = '';

  List<OrderModel> get orders => _orders;
  String get selectedStatusFilter => _selectedStatusFilter;
  String get searchQuery => _searchQuery;

  OrderController() {
    _orders = MockDataService.getInitialOrders();
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

  void acceptOrder(String orderId) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final now = DateTime.now();
      final logs = List<TrackingLogEntry>.from(_orders[index].trackingLogs)
        ..add(TrackingLogEntry(
          status: AppConstants.orderStatusAccepted,
          description: 'Order accepted by B1 Customs Admin. Preparing for dispatch.',
          timestamp: now,
        ));

      _orders[index] = _orders[index].copyWith(
        status: AppConstants.orderStatusAccepted,
        trackingLogs: logs,
      );
      notifyListeners();
    }
  }

  void rejectOrder(String orderId, String reason) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final now = DateTime.now();
      final logs = List<TrackingLogEntry>.from(_orders[index].trackingLogs)
        ..add(TrackingLogEntry(
          status: AppConstants.orderStatusRejected,
          description: 'Order rejected. Reason: $reason',
          timestamp: now,
        ));

      _orders[index] = _orders[index].copyWith(
        status: AppConstants.orderStatusRejected,
        rejectionReason: reason,
        trackingLogs: logs,
      );
      notifyListeners();
    }
  }

  void dispatchOrder(String orderId, String courierPartner, String trackingId) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final now = DateTime.now();
      final logs = List<TrackingLogEntry>.from(_orders[index].trackingLogs)
        ..add(TrackingLogEntry(
          status: AppConstants.orderStatusDispatched,
          description: 'Package handed over to $courierPartner (Tracking AWB: $trackingId)',
          timestamp: now,
        ));

      _orders[index] = _orders[index].copyWith(
        status: AppConstants.orderStatusDispatched,
        courierPartner: courierPartner,
        trackingId: trackingId,
        trackingLogs: logs,
      );
      notifyListeners();
    }
  }

  void markDelivered(String orderId) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final now = DateTime.now();
      final logs = List<TrackingLogEntry>.from(_orders[index].trackingLogs)
        ..add(TrackingLogEntry(
          status: AppConstants.orderStatusDelivered,
          description: 'Item successfully delivered to customer address.',
          timestamp: now,
        ));

      _orders[index] = _orders[index].copyWith(
        status: AppConstants.orderStatusDelivered,
        trackingLogs: logs,
      );
      notifyListeners();
    }
  }
}
