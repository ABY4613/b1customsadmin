import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/inventory_controller.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/order_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/sidebar_navigation.dart';
import '../widgets/top_header.dart';
import 'analytics/analytics_view.dart';
import 'dashboard/dashboard_view.dart';
import 'inventory/inventory_view.dart';
import 'orders/orders_view.dart';
import 'settings/settings_view.dart';

class MainLayout extends StatelessWidget {
  final AuthController authController;
  final NavigationController navigationController;
  final InventoryController inventoryController;
  final OrderController orderController;
  final DashboardController dashboardController;

  const MainLayout({
    super.key,
    required this.authController,
    required this.navigationController,
    required this.inventoryController,
    required this.orderController,
    required this.dashboardController,
  });

  Widget _buildActiveBody() {
    switch (navigationController.activeSection) {
      case NavSection.dashboard:
        return DashboardView(
          dashboardController: dashboardController,
          navigationController: navigationController,
        );
      case NavSection.inventory:
        return InventoryView(
          inventoryController: inventoryController,
        );
      case NavSection.orders:
        return OrdersView(
          orderController: orderController,
        );
      case NavSection.analytics:
        return AnalyticsView(
          orderController: orderController,
        );
      case NavSection.settings:
        return const SettingsView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: navigationController,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Row(
            children: [
              SidebarNavigation(
                navigationController: navigationController,
                orderController: orderController,
                inventoryController: inventoryController,
              ),
              Expanded(
                child: Column(
                  children: [
                    TopHeader(
                      authController: authController,
                      navigationController: navigationController,
                    ),
                    Expanded(
                      child: Container(
                        color: AppColors.background,
                        child: _buildActiveBody(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
