import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final bool isStockStatus;

  const StatusBadge({
    super.key,
    required this.status,
    this.isStockStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;

    if (isStockStatus) {
      if (status == 'Low Stock') {
        bg = AppColors.warning.withOpacity(0.15);
        fg = AppColors.warning;
        icon = Icons.warning_amber_rounded;
      } else if (status == 'Out of Stock') {
        bg = AppColors.danger.withOpacity(0.15);
        fg = AppColors.danger;
        icon = Icons.error_outline;
      } else {
        bg = AppColors.success.withOpacity(0.15);
        fg = AppColors.success;
        icon = Icons.check_circle_outline;
      }
    } else {
      switch (status) {
        case AppConstants.orderStatusPending:
          bg = AppColors.warning.withOpacity(0.15);
          fg = AppColors.warning;
          icon = Icons.hourglass_top;
          break;
        case AppConstants.orderStatusAccepted:
          bg = AppColors.info.withOpacity(0.15);
          fg = AppColors.info;
          icon = Icons.thumb_up_alt_outlined;
          break;
        case AppConstants.orderStatusDispatched:
          bg = AppColors.primary.withOpacity(0.15);
          fg = AppColors.primary;
          icon = Icons.local_shipping_outlined;
          break;
        case AppConstants.orderStatusDelivered:
          bg = AppColors.success.withOpacity(0.15);
          fg = AppColors.success;
          icon = Icons.verified_outlined;
          break;
        case AppConstants.orderStatusRejected:
          bg = AppColors.danger.withOpacity(0.15);
          fg = AppColors.danger;
          icon = Icons.cancel_outlined;
          break;
        default:
          bg = AppColors.border;
          fg = AppColors.accentWhite;
          icon = Icons.info_outline;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: fg),
          const SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              color: fg,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
