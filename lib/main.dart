import 'package:flutter/material.dart';
import 'controllers/auth_controller.dart';
import 'controllers/dashboard_controller.dart';
import 'controllers/inventory_controller.dart';
import 'controllers/navigation_controller.dart';
import 'controllers/order_controller.dart';
import 'utils/app_constants.dart';
import 'utils/app_theme.dart';
import 'views/auth/auth_view.dart';
import 'views/main_layout.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const B1CustomsAdminApp());
}

class B1CustomsAdminApp extends StatefulWidget {
  const B1CustomsAdminApp({super.key});

  @override
  State<B1CustomsAdminApp> createState() => _B1CustomsAdminAppState();
}

class _B1CustomsAdminAppState extends State<B1CustomsAdminApp> {
  late final AuthController _authController;
  late final NavigationController _navigationController;
  late final InventoryController _inventoryController;
  late final OrderController _orderController;
  late final DashboardController _dashboardController;

  @override
  void initState() {
    super.initState();
    _authController = AuthController();
    _navigationController = NavigationController();
    _inventoryController = InventoryController();
    _orderController = OrderController();
    _dashboardController = DashboardController(
      inventoryController: _inventoryController,
      orderController: _orderController,
    );
  }

  @override
  void dispose() {
    _authController.dispose();
    _navigationController.dispose();
    _inventoryController.dispose();
    _orderController.dispose();
    _dashboardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '${AppConstants.appName} - Admin Web Panel',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: ListenableBuilder(
        listenable: _authController,
        builder: (context, _) {
          if (!_authController.isAuthenticated) {
            return AuthView(authController: _authController);
          }
          return MainLayout(
            authController: _authController,
            navigationController: _navigationController,
            inventoryController: _inventoryController,
            orderController: _orderController,
            dashboardController: _dashboardController,
          );
        },
      ),
    );
  }
}
