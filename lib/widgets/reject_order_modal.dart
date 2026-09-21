import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../utils/app_colors.dart';
import 'custom_text_field.dart';

class RejectOrderModal extends StatefulWidget {
  final OrderModel order;
  final Function(String reason) onConfirmReject;

  const RejectOrderModal({
    super.key,
    required this.order,
    required this.onConfirmReject,
  });

  @override
  State<RejectOrderModal> createState() => _RejectOrderModalState();
}

class _RejectOrderModalState extends State<RejectOrderModal> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final List<String> _commonReasons = [
    'Item temporarily out of stock with supplier',
    'Customer shipping address unserviceable',
    'Pricing or coupon mismatch error',
    'Customer requested order cancellation',
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onConfirmReject(_reasonController.text.trim());
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceLight,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.cancel_outlined, color: AppColors.danger, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REJECT ORDER #${widget.order.orderNumber}',
                          style: const TextStyle(
                            color: AppColors.accentWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Customer: ${widget.order.customerName}',
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
              const Divider(height: 24),
              const Text(
                'Quick Select Reason:',
                style: TextStyle(color: AppColors.accentGrey, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _commonReasons.map((reason) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _reasonController.text = reason;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        reason,
                        style: const TextStyle(color: AppColors.accentWhite, fontSize: 12),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Detailed Rejection Reason *',
                hint: 'Type custom reason here...',
                controller: _reasonController,
                maxLines: 3,
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Rejection reason is required' : null,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.danger,
                      foregroundColor: AppColors.accentWhite,
                    ),
                    onPressed: _submit,
                    child: const Text('Confirm Rejection'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
