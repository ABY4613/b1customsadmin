import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SYSTEM & LOGISTICS CONFIGURATION',
            style: TextStyle(
              color: AppColors.accentWhite,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const Text(
            'API Contracts, Courier Webhooks, and Low Stock Thresholds.',
            style: TextStyle(color: AppColors.accentGrey, fontSize: 12),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('API CONTRACTS & ENDPOINTS', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildInfoRow('Base API URL', AppConstants.apiBaseUrl),
                _buildInfoRow('Auth Endpoint', AppConstants.authEndpoint),
                _buildInfoRow('Products Endpoint', AppConstants.productsEndpoint),
                _buildInfoRow('Orders Endpoint', AppConstants.ordersEndpoint),
                const Divider(height: 24),
                const Text('SYSTEM CONSTANTS', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildInfoRow('Low Stock Threshold Alert', '${AppConstants.lowStockThreshold} units'),
                _buildInfoRow('App Version', AppConstants.appVersion),
                _buildInfoRow('Encryption Spec', 'AES-256 Auth Token Header Injection'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: AppColors.accentGrey, fontSize: 13)),
          Text(value, style: const TextStyle(color: AppColors.accentWhite, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}
