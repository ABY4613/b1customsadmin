import 'package:flutter/material.dart';
import '../../controllers/order_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/formatters.dart';

class AnalyticsView extends StatelessWidget {
  final OrderController orderController;

  const AnalyticsView({
    super.key,
    required this.orderController,
  });

  @override
  Widget build(BuildContext context) {
    final totalSales = orderController.totalSalesAmount;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SALES & REVENUE ANALYTICS',
            style: TextStyle(
              color: AppColors.accentWhite,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const Text(
            'Performance metrics, category distribution, and order volume insights.',
            style: TextStyle(color: AppColors.accentGrey, fontSize: 12),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
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
                      const Text('TOTAL GROSS SALES',
                          style: TextStyle(color: AppColors.accentGrey, fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        AppFormatters.formatCurrency(totalSales),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Icon(Icons.trending_up, color: AppColors.success, size: 16),
                          SizedBox(width: 4),
                          Text('+24.6% vs previous month',
                              style: TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
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
                      const Text('AVERAGE ORDER VALUE (AOV)',
                          style: TextStyle(color: AppColors.accentGrey, fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        AppFormatters.formatCurrency(totalSales / (orderController.orders.isEmpty ? 1 : orderController.orders.length)),
                        style: const TextStyle(
                          color: AppColors.accentWhite,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Icon(Icons.thumb_up_alt_outlined, color: AppColors.info, size: 16),
                          SizedBox(width: 4),
                          Text('High cart conversion rate',
                              style: TextStyle(color: AppColors.info, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Chart Visual Mock Container
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MONTHLY SALES VELOCITY (EXHAUSTS vs CRASH GUARDS vs ECU)',
                  style: TextStyle(
                    color: AppColors.accentWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBar('Jan', 0.4, AppColors.primary),
                      _buildBar('Feb', 0.65, AppColors.primary),
                      _buildBar('Mar', 0.5, AppColors.primary),
                      _buildBar('Apr', 0.8, AppColors.primary),
                      _buildBar('May', 0.95, AppColors.primary),
                      _buildBar('Jun', 0.7, AppColors.primary),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double heightFactor, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 32,
          height: 160 * heightFactor,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: AppColors.accentGrey, fontSize: 12)),
      ],
    );
  }
}
