import 'package:flutter/material.dart';
import 'inventory_controller.dart';
import 'order_controller.dart';

class DashboardController extends ChangeNotifier {
  final InventoryController inventoryController;
  final OrderController orderController;

  DashboardController({
    required this.inventoryController,
    required this.orderController,
  }) {
    inventoryController.addListener(_onDataChanged);
    orderController.addListener(_onDataChanged);
  }

  void _onDataChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    inventoryController.removeListener(_onDataChanged);
    orderController.removeListener(_onDataChanged);
    super.dispose();
  }

  double get totalSales => orderController.totalSalesAmount;
  int get activeOrders => orderController.activeOrdersCount;
  int get lowStockAlerts => inventoryController.lowStockCount;
  int get dispatchPending => orderController.dispatchPendingCount;
  int get pendingOrders => orderController.pendingOrdersCount;
}
