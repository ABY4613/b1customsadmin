import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';
import 'status_badge.dart';

class OrderDetailModal extends StatelessWidget {
  final OrderModel order;

  const OrderDetailModal({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceLight,
      child: Container(
        width: 700,
        constraints: const BoxConstraints(maxHeight: 750),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modal Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'ORDER #${order.orderNumber}',
                      style: const TextStyle(
                        color: AppColors.accentWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 12),
                    StatusBadge(status: order.status),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.accentGrey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(height: 24),
            // Body Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Customer & Shipping Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CUSTOMER & SHIPMENT DETAILS',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Customer Name',
                                        style: TextStyle(color: AppColors.accentGrey, fontSize: 11)),
                                    Text(order.customerName,
                                        style: const TextStyle(
                                            color: AppColors.accentWhite,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    const Text('Email Address',
                                        style: TextStyle(color: AppColors.accentGrey, fontSize: 11)),
                                    Text(order.customerEmail,
                                        style: const TextStyle(color: AppColors.accentWhite)),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Phone Number',
                                        style: TextStyle(color: AppColors.accentGrey, fontSize: 11)),
                                    Text(order.customerPhone,
                                        style: const TextStyle(color: AppColors.accentWhite)),
                                    const SizedBox(height: 8),
                                    const Text('Order Date',
                                        style: TextStyle(color: AppColors.accentGrey, fontSize: 11)),
                                    Text(AppFormatters.formatDate(order.createdAt),
                                        style: const TextStyle(color: AppColors.accentWhite)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text('Delivery Address',
                              style: TextStyle(color: AppColors.accentGrey, fontSize: 11)),
                          Text(
                            order.shippingAddress,
                            style: const TextStyle(color: AppColors.accentWhite, fontSize: 13),
                          ),
                          if (order.courierPartner != null && order.trackingId != null) ...[
                            const Divider(height: 20),
                            Row(
                              children: [
                                const Icon(Icons.local_shipping, color: AppColors.primary, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  'Partner: ${order.courierPartner} | AWB: ${order.trackingId}',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (order.rejectionReason != null) ...[
                            const Divider(height: 20),
                            Row(
                              children: [
                                const Icon(Icons.warning, color: AppColors.danger, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Rejection Reason: ${order.rejectionReason}',
                                    style: const TextStyle(
                                      color: AppColors.danger,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Itemized Order Table
                    const Text(
                      'ORDERED ITEMS',
                      style: TextStyle(
                        color: AppColors.accentWhite,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          ...order.items.map((item) {
                            return Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      item.imageUrl,
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 48,
                                        height: 48,
                                        color: AppColors.border,
                                        child: const Icon(Icons.two_wheeler, color: AppColors.accentGrey),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.productTitle,
                                          style: const TextStyle(
                                            color: AppColors.accentWhite,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          'SKU: ${item.productSku}',
                                          style: const TextStyle(
                                            color: AppColors.accentGrey,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${item.quantity} x ${AppFormatters.formatCurrency(item.price)}',
                                    style: const TextStyle(
                                      color: AppColors.accentGrey,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    AppFormatters.formatCurrency(item.subtotal),
                                    style: const TextStyle(
                                      color: AppColors.accentWhite,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          const Divider(height: 1),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'TOTAL BILLING AMOUNT',
                                  style: TextStyle(
                                    color: AppColors.accentWhite,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  AppFormatters.formatCurrency(order.totalAmount),
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Tracking History Logs
                    const Text(
                      'STATUS & LOGISTICS TIMELINE',
                      style: TextStyle(
                        color: AppColors.accentWhite,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: order.trackingLogs.map((log) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.radio_button_checked,
                                    size: 16, color: AppColors.primary),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            log.status,
                                            style: const TextStyle(
                                              color: AppColors.accentWhite,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text(
                                            AppFormatters.formatDate(log.timestamp),
                                            style: const TextStyle(
                                              color: AppColors.textMuted,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        log.description,
                                        style: const TextStyle(
                                          color: AppColors.accentGrey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
