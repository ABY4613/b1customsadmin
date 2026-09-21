class OrderItemModel {
  final String productId;
  final String productTitle;
  final String productSku;
  final double price;
  final int quantity;
  final String imageUrl;

  OrderItemModel({
    required this.productId,
    required this.productTitle,
    required this.productSku,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  double get subtotal => price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productTitle': productTitle,
      'productSku': productSku,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['productId'] ?? '',
      productTitle: json['productTitle'] ?? '',
      productSku: json['productSku'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

class TrackingLogEntry {
  final String status;
  final String description;
  final DateTime timestamp;

  TrackingLogEntry({
    required this.status,
    required this.description,
    required this.timestamp,
  });
}

class OrderModel {
  final String id;
  final String orderNumber;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String shippingAddress;
  final List<OrderItemModel> items;
  final double totalAmount;
  final String status; // Pending, Accepted, Dispatched, Delivered, Rejected
  final DateTime createdAt;
  final String? rejectionReason;
  final String? courierPartner;
  final String? trackingId;
  final List<TrackingLogEntry> trackingLogs;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.shippingAddress,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.rejectionReason,
    this.courierPartner,
    this.trackingId,
    List<TrackingLogEntry>? trackingLogs,
  }) : trackingLogs = trackingLogs ?? [];

  OrderModel copyWith({
    String? id,
    String? orderNumber,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    String? shippingAddress,
    List<OrderItemModel>? items,
    double? totalAmount,
    String? status,
    DateTime? createdAt,
    String? rejectionReason,
    String? courierPartner,
    String? trackingId,
    List<TrackingLogEntry>? trackingLogs,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      courierPartner: courierPartner ?? this.courierPartner,
      trackingId: trackingId ?? this.trackingId,
      trackingLogs: trackingLogs ?? this.trackingLogs,
    );
  }
}
