import 'package:flutter/material.dart';
import '../../controllers/order_controller.dart';
import '../../models/order_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/formatters.dart';
import '../../widgets/dispatch_order_modal.dart';
import '../../widgets/order_detail_modal.dart';
import '../../widgets/reject_order_modal.dart';
import '../../widgets/status_badge.dart';

class OrdersView extends StatefulWidget {
  final OrderController orderController;

  const OrdersView({
    super.key,
    required this.orderController,
  });

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showOrderDetail(OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => OrderDetailModal(order: order),
    );
  }

  void _showRejectModal(OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => RejectOrderModal(
        order: order,
        onConfirmReject: (reason) {
          widget.orderController.rejectOrder(order.id, reason);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Order #${order.orderNumber} rejected.'),
              backgroundColor: AppColors.danger,
            ),
          );
        },
      ),
    );
  }

  void _showDispatchModal(OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => DispatchOrderModal(
        order: order,
        onConfirmDispatch: (courier, trackingId) {
          widget.orderController.dispatchOrder(order.id, courier, trackingId);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Order #${order.orderNumber} dispatched via $courier (AWB: $trackingId)'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.orderController,
      builder: (context, _) {
        final orders = widget.orderController.filteredOrders;
        final selectedStatusFilter = widget.orderController.selectedStatusFilter;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header title & info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ORDER PROCESSING & DISPATCH LIFECYCLE',
                        style: TextStyle(
                          color: AppColors.accentWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'Manage incoming rider queues, issue one-click acceptances/rejections, and set courier AWB tracking.',
                        style: TextStyle(color: AppColors.accentGrey, fontSize: 12),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.shopping_bag, color: AppColors.primary, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.orderController.orders.length} Total Orders',
                          style: const TextStyle(
                            color: AppColors.accentWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Search & Filter Status Chips
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: (val) => widget.orderController.setSearchQuery(val),
                      style: const TextStyle(color: AppColors.accentWhite, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Search by Order #, Customer Name, Email, or AWB Tracking ID...',
                        prefixIcon: const Icon(Icons.search, color: AppColors.accentGrey),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: AppColors.accentGrey),
                                onPressed: () {
                                  _searchController.clear();
                                  widget.orderController.setSearchQuery('');
                                },
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: AppConstants.orderStatuses.map((status) {
                          final isSelected = selectedStatusFilter == status;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              selected: isSelected,
                              label: Text(status),
                              labelStyle: TextStyle(
                                color: isSelected ? AppColors.background : AppColors.accentWhite,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                fontSize: 12,
                              ),
                              selectedColor: AppColors.primary,
                              backgroundColor: AppColors.surfaceLight,
                              side: BorderSide(
                                color: isSelected ? AppColors.primary : AppColors.border,
                              ),
                              onSelected: (_) {
                                widget.orderController.setStatusFilter(status);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Incoming Order Queue Table
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: orders.isEmpty
                    ? Container(
                        padding: const EdgeInsets.all(40),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            const Icon(Icons.inbox_outlined, color: AppColors.textMuted, size: 48),
                            const SizedBox(height: 12),
                            const Text(
                              'No orders found matching the active filter.',
                              style: TextStyle(color: AppColors.accentGrey, fontSize: 14),
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton(
                              onPressed: () {
                                _searchController.clear();
                                widget.orderController.setSearchQuery('');
                                widget.orderController.setStatusFilter('All Statuses');
                              },
                              child: const Text('Show All Orders'),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 20,
                          headingRowColor: WidgetStateProperty.all(AppColors.surfaceLight),
                          dataRowMaxHeight: 76,
                          columns: const [
                            DataColumn(label: Text('ORDER # & DATE', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('CUSTOMER DETAILS', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('ITEMS ORDERED', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('BILLING TOTAL', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('WORKFLOW ACTIONS', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: orders.map((order) {
                            return DataRow(
                              cells: [
                                // Order # and Date
                                DataCell(
                                  InkWell(
                                    onTap: () => _showOrderDetail(order),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          order.orderNumber,
                                          style: const TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          AppFormatters.formatDate(order.createdAt),
                                          style: const TextStyle(color: AppColors.accentGrey, fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Customer Info
                                DataCell(
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.customerName,
                                        style: const TextStyle(
                                          color: AppColors.accentWhite,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        '${order.customerEmail} • ${order.customerPhone}',
                                        style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                                // Items Breakdown Brief
                                DataCell(
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${order.items.length} item(s)',
                                        style: const TextStyle(
                                          color: AppColors.accentWhite,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        order.items.map((i) => i.productTitle).join(', '),
                                        style: const TextStyle(color: AppColors.accentGrey, fontSize: 11),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                // Total Amount
                                DataCell(
                                  Text(
                                    AppFormatters.formatCurrency(order.totalAmount),
                                    style: const TextStyle(
                                      color: AppColors.accentWhite,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                // Status Badge
                                DataCell(StatusBadge(status: order.status)),
                                // Workflow Actions (Accept / Reject / Dispatch / Details)
                                DataCell(
                                  Row(
                                    children: [
                                      // If Pending -> Show Accept & Reject buttons
                                      if (order.status == AppConstants.orderStatusPending) ...[
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.info,
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          ),
                                          onPressed: () {
                                            widget.orderController.acceptOrder(order.id);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Accepted Order #${order.orderNumber}'),
                                                backgroundColor: AppColors.info,
                                              ),
                                            );
                                          },
                                          child: const Text('Accept', style: TextStyle(fontSize: 12)),
                                        ),
                                        const SizedBox(width: 6),
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: AppColors.danger,
                                            side: const BorderSide(color: AppColors.danger),
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                          ),
                                          onPressed: () => _showRejectModal(order),
                                          child: const Text('Reject', style: TextStyle(fontSize: 12)),
                                        ),
                                      ]
                                      // If Accepted -> Show Dispatch Button
                                      else if (order.status == AppConstants.orderStatusAccepted) ...[
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          ),
                                          onPressed: () => _showDispatchModal(order),
                                          icon: const Icon(Icons.local_shipping, size: 14),
                                          label: const Text('Dispatch Order', style: TextStyle(fontSize: 12)),
                                        ),
                                      ]
                                      // If Dispatched -> Show Mark Delivered option
                                      else if (order.status == AppConstants.orderStatusDispatched) ...[
                                        OutlinedButton.icon(
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: AppColors.success,
                                            side: const BorderSide(color: AppColors.success),
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                          ),
                                          onPressed: () {
                                            widget.orderController.markDelivered(order.id);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Order #${order.orderNumber} marked as Delivered'),
                                                backgroundColor: AppColors.success,
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.check_circle_outline, size: 14),
                                          label: const Text('Mark Delivered', style: TextStyle(fontSize: 12)),
                                        ),
                                      ],
                                      const SizedBox(width: 6),
                                      IconButton(
                                        icon: const Icon(Icons.visibility_outlined, color: AppColors.accentGrey, size: 20),
                                        onPressed: () => _showOrderDetail(order),
                                        tooltip: 'View Full Order & Tracking Details',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
