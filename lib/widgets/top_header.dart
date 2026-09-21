import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../controllers/navigation_controller.dart';
import '../utils/app_colors.dart';

class TopHeader extends StatelessWidget {
  final AuthController authController;
  final NavigationController navigationController;

  const TopHeader({
    super.key,
    required this.authController,
    required this.navigationController,
  });

  String _getTitle() {
    switch (navigationController.activeSection) {
      case NavSection.dashboard:
        return 'Executive Overview';
      case NavSection.inventory:
        return 'Product & Inventory Hub';
      case NavSection.orders:
        return 'Order Processing & Dispatch Workflow';
      case NavSection.analytics:
        return 'Sales & Performance Analytics';
      case NavSection.settings:
        return 'System & API Settings';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = authController.currentUser;
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              navigationController.isSidebarCollapsed
                  ? Icons.menu_open
                  : Icons.menu,
              color: AppColors.accentWhite,
            ),
            onPressed: () => navigationController.toggleSidebar(),
            tooltip: 'Toggle Navigation Menu',
          ),
          const SizedBox(width: 12),
          Text(
            _getTitle(),
            style: TextStyle(
              color: AppColors.accentWhite,
              fontSize: isMobile ? 16 : 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
          const Spacer(),
          // Live Sync Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.success.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.fiber_manual_record, size: 8, color: AppColors.success),
                SizedBox(width: 6),
                Text(
                  'SYSTEM ONLINE',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Admin Profile Avatar
          PopupMenuButton<String>(
            color: AppColors.surfaceLight,
            shadowColor: Colors.black54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.borderHighlight),
            ),
            offset: const Offset(0, 50),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary,
                  backgroundImage: user?.avatarUrl != null
                      ? NetworkImage(user!.avatarUrl!)
                      : null,
                  child: user?.avatarUrl == null
                      ? Text(
                          (user?.name ?? 'A')[0].toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.background,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                if (!isMobile) ...[
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'Admin User',
                        style: const TextStyle(
                          color: AppColors.accentWhite,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        user?.role ?? 'Master Admin',
                        style: const TextStyle(
                          color: AppColors.accentGrey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_drop_down, color: AppColors.accentGrey),
                ],
              ],
            ),
            onSelected: (value) {
              if (value == 'logout') {
                authController.logout();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.email ?? 'admin@b1customs.com',
                      style: const TextStyle(
                        color: AppColors.accentWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Token: ${user != null && user.token.length >= 15 ? user.token.substring(0, 15) : user?.token}...',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                    const Divider(height: 16),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: AppColors.danger, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Sign Out',
                      style: TextStyle(color: AppColors.danger, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
