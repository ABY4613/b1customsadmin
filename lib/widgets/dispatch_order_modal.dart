import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import 'custom_text_field.dart';

class DispatchOrderModal extends StatefulWidget {
  final OrderModel order;
  final Function(String courier, String trackingId) onConfirmDispatch;

  const DispatchOrderModal({
    super.key,
    required this.order,
    required this.onConfirmDispatch,
  });

  @override
  State<DispatchOrderModal> createState() => _DispatchOrderModalState();
}

class _DispatchOrderModalState extends State<DispatchOrderModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _trackingIdController;
  String _selectedCourier = AppConstants.courierPartners[0];

  @override
  void initState() {
    super.initState();
    _trackingIdController = TextEditingController();
    _generateMockTrackingId(_selectedCourier);
  }

  @override
  void dispose() {
    _trackingIdController.dispose();
    super.dispose();
  }

  void _generateMockTrackingId(String courier) {
    final prefix = courier.substring(0, 2).toUpperCase();
    final randomNum = (10000000 + (DateTime.now().millisecondsSinceEpoch % 89999999)).toString();
    setState(() {
      _trackingIdController.text = '$prefix-$randomNum-IN';
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onConfirmDispatch(
        _selectedCourier,
        _trackingIdController.text.trim(),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceLight,
      child: Container(
        width: 520,
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
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.local_shipping_outlined, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DISPATCH SHIPMENT #${widget.order.orderNumber}',
                          style: const TextStyle(
                            color: AppColors.accentWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Recipient: ${widget.order.customerName}',
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
                'Courier Logistics Partner *',
                style: TextStyle(
                  color: AppColors.accentWhite,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCourier,
                    isExpanded: true,
                    dropdownColor: AppColors.surfaceLight,
                    style: const TextStyle(color: AppColors.accentWhite, fontSize: 14),
                    items: AppConstants.courierPartners
                        .map((c) => DropdownMenuItem(
                              value: c,
                              child: Text(c),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedCourier = val;
                        });
                        _generateMockTrackingId(val);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Stack(
                children: [
                  CustomTextField(
                    label: 'Courier Tracking AWB / Waybill ID *',
                    hint: 'e.g. BD-99481029-IN',
                    controller: _trackingIdController,
                    validator: (val) =>
                        val == null || val.trim().isEmpty ? 'Tracking ID required' : null,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: TextButton(
                      onPressed: () => _generateMockTrackingId(_selectedCourier),
                      child: const Text(
                        'Generate AWB',
                        style: TextStyle(color: AppColors.primary, fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, color: AppColors.info, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Dispatching updates the tracking status for customer mobile & web notifications.',
                        style: TextStyle(color: AppColors.accentGrey, fontSize: 11),
                      ),
                    ),
                  ],
                ),
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
                  ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.send_outlined, size: 16),
                    label: const Text('Confirm & Dispatch'),
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
