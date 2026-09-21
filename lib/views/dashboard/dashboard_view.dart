import 'package:flutter/material.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/navigation_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/formatters.dart';
import '../../widgets/kpi_card.dart';
import '../../widgets/status_badge.dart';

class DashboardView extends StatelessWidget {
  final DashboardController dashboardController;
  final NavigationController navigationController;

  const DashboardView({
    super.key,
    required this.dashboardController,
    required this.navigationController,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;
    final isTablet = screenWidth >= 800 && screenWidth < 1200;

    return ListenableBuilder(
      listenable: dashboardController,
      builder: (context, _) {
        final totalSales = dashboardController.totalSales;
        final activeOrders = dashboardController.activeOrders;
        final lowStockAlerts = dashboardController.lowStockAlerts;
        final dispatchPending = dashboardController.dispatchPending;
        final pendingOrdersCount = dashboardController.pendingOrders;

        final recentOrders = dashboardController.orderController.orders.take(4).toList();
        final lowStockItems = dashboardController.inventoryController.lowStockProducts;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.cardGradient,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderHighlight),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'B1 CUSTOMS PERFORMANCE HUB',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Real-Time Accessories Inventory & Dispatch Control',
                            style: TextStyle(
                              color: AppColors.accentWhite,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Manage stock velocity, accept incoming rider orders, and dispatch shipments with live courier AWB tracking.',
                            style: TextStyle(
                              color: AppColors.accentGrey,
                              fontSize: isMobile ? 12 : 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isMobile) ...[
                      const SizedBox(width: 20),
                      ElevatedButton.icon(
                        onPressed: () => navigationController.setSection(NavSection.orders),
                        icon: const Icon(Icons.flash_on, size: 18),
                        label: Text('Process $pendingOrdersCount Incoming Orders'),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // KPI Metric Cards Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 4;
                  if (isMobile) {
                    crossAxisCount = 1;
                  } else if (isTablet) {
                    crossAxisCount = 2;
                  }

                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: isMobile ? 2.2 : 1.5,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      KPICard(
                        title: 'Total Revenue Sales',
                        value: AppFormatters.formatCurrency(totalSales),
                        trendText: '+18.4%',
                        isPositive: true,
                        icon: Icons.payments_outlined,
                        accentColor: AppColors.primary,
                        onTap: () => navigationController.setSection(NavSection.analytics),
                      ),
                      KPICard(
                        title: 'Active Rider Orders',
                        value: '$activeOrders',
                        trendText: '+12%',
                        isPositive: true,
                        icon: Icons.shopping_bag_outlined,
                        accentColor: AppColors.info,
                        onTap: () => navigationController.setSection(NavSection.orders),
                      ),
                      KPICard(
                        title: 'Low Stock Alerts',
                        value: '$lowStockAlerts',
                        trendText: lowStockAlerts > 0 ? 'Requires Restock' : 'Optimal Level',
                        isPositive: lowStockAlerts == 0,
                        icon: Icons.warning_amber_rounded,
                        accentColor: AppColors.warning,
                        onTap: () => navigationController.setSection(NavSection.inventory),
                      ),
                      KPICard(
                        title: 'Dispatch Pending',
                        value: '$dispatchPending',
                        trendText: 'Ready for Courier',
                        isPositive: true,
                        icon: Icons.local_shipping_outlined,
                        accentColor: AppColors.purple,
                        onTap: () => navigationController.setSection(NavSection.orders),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              // Low Stock Warning Banner if items exist
              if (lowStockItems.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.warning.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CRITICAL STOCK ALERT: ${lowStockItems.length} Accessories Below Threshold (${AppConstants.lowStockThreshold} units)',
                              style: const TextStyle(
                                color: AppColors.warning,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'Items: ${lowStockItems.map((e) => "${e.title} (${e.stock} left)").join(", ")}',
                              style: const TextStyle(color: AppColors.accentGrey, fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () => navigationController.setSection(NavSection.inventory),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.warning,
                          side: const BorderSide(color: AppColors.warning),
                        ),
                        child: const Text('Restock Now'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
              // Main Dashboard Two-Column Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recent Incoming Orders Table
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'RECENT ORDER QUEUE',
                                    style: TextStyle(
                                      color: AppColors.accentWhite,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  Text(
                                    'Live incoming rider orders requiring admin action',
                                    style: TextStyle(
                                      color: AppColors.accentGrey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              TextButton.icon(
                                onPressed: () =>
                                    navigationController.setSection(NavSection.orders),
                                icon: const Icon(Icons.arrow_forward, size: 16),
                                label: const Text('View All Orders Hub'),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowColor: WidgetStateProperty.all(AppColors.surfaceLight),
                              columns: const [
                                DataColumn(label: Text('ORDER #', style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text('CUSTOMER', style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text('ITEMS', style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text('AMOUNT', style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold))),
                              ],
                              rows: recentOrders.map((order) {
                                return DataRow(cells: [
                                  DataCell(Text(order.orderNumber, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary))),
                                  DataCell(Text(order.customerName, style: const TextStyle(color: AppColors.accentWhite))),
                                  DataCell(Text('${order.items.length} accessory items', style: const TextStyle(color: AppColors.accentGrey))),
                                  DataCell(Text(AppFormatters.formatCurrency(order.totalAmount), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentWhite))),
                                  DataCell(StatusBadge(status: order.status)),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!isMobile) ...[
                    const SizedBox(width: 20),
                    // Quick Action Panel & System Info
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'QUICK ADMIN ACTIONS',
                              style: TextStyle(
                                color: AppColors.accentWhite,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ListTile(
                              tileColor: AppColors.surfaceLight,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(color: AppColors.border),
                              ),
                              leading: const CircleAvatar(
                                backgroundColor: AppColors.primary,
                                child: Icon(Icons.add, color: AppColors.background),
                              ),
                              title: const Text('Add Accessory Product', style: TextStyle(color: AppColors.accentWhite, fontWeight: FontWeight.bold)),
                              subtitle: const Text('Add Exhausts, Filters, Bend Pipes', style: TextStyle(color: AppColors.accentGrey, fontSize: 11)),
                              trailing: const Icon(Icons.chevron_right, color: AppColors.accentGrey),
                              onTap: () => navigationController.setSection(NavSection.inventory),
                            ),
                            const SizedBox(height: 12),
                            ListTile(
                              tileColor: AppColors.surfaceLight,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(color: AppColors.border),
                              ),
                              leading: const CircleAvatar(
                                backgroundColor: AppColors.info,
                                child: Icon(Icons.local_shipping, color: AppColors.accentWhite),
                              ),
                              title: const Text('Dispatch Pending Queue', style: TextStyle(color: AppColors.accentWhite, fontWeight: FontWeight.bold)),
                              subtitle: Text('$dispatchPending orders awaiting courier AWB', style: const TextStyle(color: AppColors.accentGrey, fontSize: 11)),
                              trailing: const Icon(Icons.chevron_right, color: AppColors.accentGrey),
                              onTap: () => navigationController.setSection(NavSection.orders),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'B1 LOGISTICS INTEGRATION',
                              style: TextStyle(
                                color: AppColors.accentWhite,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('BlueDart Direct Integration', style: TextStyle(color: AppColors.accentWhite, fontSize: 12)),
                                      Text('CONNECTED', style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Delhivery API Webhook', style: TextStyle(color: AppColors.accentWhite, fontSize: 12)),
                                      Text('ACTIVE', style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('DHL International Air', style: TextStyle(color: AppColors.accentWhite, fontSize: 12)),
                                      Text('ACTIVE', style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
