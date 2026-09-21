import 'package:flutter/material.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/order_controller.dart';
import '../controllers/inventory_controller.dart';
import '../utils/app_colors.dart';

class SidebarNavigation extends StatelessWidget {
  final NavigationController navigationController;
  final OrderController orderController;
  final InventoryController inventoryController;

  const SidebarNavigation({
    super.key,
    required this.navigationController,
    required this.orderController,
    required this.inventoryController,
  });

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required NavSection section,
    int? badgeCount,
    Color? badgeColor,
  }) {
    final isSelected = navigationController.activeSection == section;
    final isCollapsed = navigationController.isSidebarCollapsed;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: () => navigationController.setSection(section),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? 12 : 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isSelected
                ? Border.all(color: AppColors.primary.withOpacity(0.4))
                : null,
          ),
          child: Row(
            mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.accentGrey,
                size: 22,
              ),
              if (!isCollapsed) ...[
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? AppColors.accentWhite : AppColors.accentGrey,
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
                if (badgeCount != null && badgeCount > 0) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: badgeColor ?? AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$badgeCount',
                      style: const TextStyle(
                        color: AppColors.background,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCollapsed = navigationController.isSidebarCollapsed;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: isCollapsed ? 75 : 260,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          // Branding Header
          Container(
            height: 70,
            padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 10 : 20),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: const Icon(Icons.two_wheeler, color: AppColors.primary, size: 24),
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: 12),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'B1 CUSTOMS',
                        style: TextStyle(
                          color: AppColors.accentWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        'ADMIN CONSOLE',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Navigation Links
          Expanded(
            child: ListView(
              children: [
                _buildNavItem(
                  context: context,
                  icon: Icons.dashboard_outlined,
                  title: 'Dashboard',
                  section: NavSection.dashboard,
                ),
                ListenableBuilder(
                  listenable: inventoryController,
                  builder: (context, _) {
                    return _buildNavItem(
                      context: context,
                      icon: Icons.inventory_2_outlined,
                      title: 'Inventory Catalog',
                      section: NavSection.inventory,
                      badgeCount: inventoryController.lowStockCount,
                      badgeColor: AppColors.warning,
                    );
                  },
                ),
                ListenableBuilder(
                  listenable: orderController,
                  builder: (context, _) {
                    return _buildNavItem(
                      context: context,
                      icon: Icons.shopping_bag_outlined,
                      title: 'Orders Hub',
                      section: NavSection.orders,
                      badgeCount: orderController.pendingOrdersCount,
                      badgeColor: AppColors.primary,
                    );
                  },
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.insights_outlined,
                  title: 'Analytics & Revenue',
                  section: NavSection.analytics,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.settings_outlined,
                  title: 'System Settings',
                  section: NavSection.settings,
                ),
              ],
            ),
          ),
          // Footer Version Info
          if (!isCollapsed)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'B1 Customs Engine',
                    style: TextStyle(
                      color: AppColors.accentWhite,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'v2.4.0-PROD • Online',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
