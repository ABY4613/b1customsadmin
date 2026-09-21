import '../models/product_model.dart';
import '../models/order_model.dart';
import '../utils/app_constants.dart';

class MockDataService {
  static List<ProductModel> getInitialProducts() {
    final now = DateTime.now();
    return [
      ProductModel(
        id: 'prod_1',
        title: 'B1 Stealth Slip-On Titanium Exhaust',
        sku: 'B1-EX-TT-001',
        category: 'Exhaust',
        price: 34999.0,
        stock: 18,
        description: 'Race-spec titanium slip-on canister with real carbon fiber end-cap. Delivers +4.2 HP gains and deep acoustic note.',
        imageUrl: 'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=500&auto=format&fit=crop&q=60',
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      ProductModel(
        id: 'prod_2',
        title: 'DNA High-Performance Stage 3 Air Filter',
        sku: 'B1-FL-DN-002',
        category: 'Filters',
        price: 6499.0,
        stock: 5, // Low stock item
        description: 'Multi-layer cotton gauze air filter with +38% increased airflow velocity for aggressive throttle response.',
        imageUrl: 'https://images.unsplash.com/photo-1486006920555-c77dce18193b?w=500&auto=format&fit=crop&q=60',
        createdAt: now.subtract(const Duration(days: 25)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      ProductModel(
        id: 'prod_3',
        title: 'B1 Ultra-Duty Tubular Crash Guard Frame',
        sku: 'B1-CG-HD-003',
        category: 'Crash Guards',
        price: 8999.0,
        stock: 12,
        description: 'Cold-rolled seamless steel tubing with CNC slider pucks. Ultimate crash protection for engine casing and fairings.',
        imageUrl: 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=500&auto=format&fit=crop&q=60',
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      ProductModel(
        id: 'prod_4',
        title: 'Full Stainless Steel Header Bend Pipe',
        sku: 'B1-BP-SS-004',
        category: 'Bend Pipes',
        price: 11499.0,
        stock: 8, // Low stock
        description: 'Mandrel-bent T304 stainless steel header pipe eliminating catalyst restrictions for max high-RPM exhaust flow.',
        imageUrl: 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=500&auto=format&fit=crop&q=60',
        createdAt: now.subtract(const Duration(days: 18)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
      ProductModel(
        id: 'prod_5',
        title: 'B1 CNC Foldable 6-Stage Adjustable Levers',
        sku: 'B1-HB-LV-005',
        category: 'Handlebars & Levers',
        price: 3299.0,
        stock: 24,
        description: 'Aircraft-grade 6061-T6 aluminum levers with stainless hardware, extendable length, and anti-snap folding mechanism.',
        imageUrl: 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=500&auto=format&fit=crop&q=60',
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now.subtract(const Duration(days: 10)),
      ),
      ProductModel(
        id: 'prod_6',
        title: 'FuelX Autotune Performance ECU Module',
        sku: 'B1-EC-FX-006',
        category: 'Performance ECU',
        price: 14999.0,
        stock: 3, // Low stock
        description: 'Plug-and-play electronic fuel injection optimizer. Autotunes air-fuel ratios in real time for engine smoothness.',
        imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=500&auto=format&fit=crop&q=60',
        createdAt: now.subtract(const Duration(days: 12)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      ProductModel(
        id: 'prod_7',
        title: 'EBC Sintered Double-H Racing Brake Pads',
        sku: 'B1-BR-EB-007',
        category: 'Brake Systems',
        price: 4199.0,
        stock: 30,
        description: 'Highest friction HH rating brake pads for zero fade braking efficiency under extreme track and street conditions.',
        imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=500&auto=format&fit=crop&q=60',
        createdAt: now.subtract(const Duration(days: 8)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
    ];
  }

  static List<OrderModel> getInitialOrders() {
    final now = DateTime.now();
    return [
      OrderModel(
        id: 'ord_101',
        orderNumber: 'B1-ORD-9402',
        customerName: 'Vikramaditya Sharma',
        customerEmail: 'vikram.sharma@example.com',
        customerPhone: '+91 98765 43210',
        shippingAddress: '42 Apex Towers, Sector 62, Gurgaon, Haryana 122001',
        items: [
          OrderItemModel(
            productId: 'prod_1',
            productTitle: 'B1 Stealth Slip-On Titanium Exhaust',
            productSku: 'B1-EX-TT-001',
            price: 34999.0,
            quantity: 1,
            imageUrl: 'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=500&auto=format&fit=crop&q=60',
          ),
          OrderItemModel(
            productId: 'prod_2',
            productTitle: 'DNA High-Performance Stage 3 Air Filter',
            productSku: 'B1-FL-DN-002',
            price: 6499.0,
            quantity: 1,
            imageUrl: 'https://images.unsplash.com/photo-1486006920555-c77dce18193b?w=500&auto=format&fit=crop&q=60',
          ),
        ],
        totalAmount: 41498.0,
        status: AppConstants.orderStatusPending,
        createdAt: now.subtract(const Duration(hours: 2)),
        trackingLogs: [
          TrackingLogEntry(
            status: 'Order Placed',
            description: 'Customer confirmed payment and placed order via B1 Customs App',
            timestamp: now.subtract(const Duration(hours: 2)),
          ),
        ],
      ),
      OrderModel(
        id: 'ord_102',
        orderNumber: 'B1-ORD-9398',
        customerName: 'Rohan Deshmukh',
        customerEmail: 'rohan.deshmukh@example.com',
        customerPhone: '+91 98112 34567',
        shippingAddress: '15 Lotus Boulevard, Koramangala 4th Block, Bengaluru, Karnataka 560034',
        items: [
          OrderItemModel(
            productId: 'prod_3',
            productTitle: 'B1 Ultra-Duty Tubular Crash Guard Frame',
            productSku: 'B1-CG-HD-003',
            price: 8999.0,
            quantity: 1,
            imageUrl: 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=500&auto=format&fit=crop&q=60',
          ),
        ],
        totalAmount: 8999.0,
        status: AppConstants.orderStatusAccepted,
        createdAt: now.subtract(const Duration(hours: 6)),
        trackingLogs: [
          TrackingLogEntry(
            status: 'Order Placed',
            description: 'Order logged in system',
            timestamp: now.subtract(const Duration(hours: 6)),
          ),
          TrackingLogEntry(
            status: 'Accepted',
            description: 'Order confirmed by Admin. Allocation in progress at Warehouse 1',
            timestamp: now.subtract(const Duration(hours: 4)),
          ),
        ],
      ),
      OrderModel(
        id: 'ord_103',
        orderNumber: 'B1-ORD-9385',
        customerName: 'Ananya Roy',
        customerEmail: 'ananya.roy@example.com',
        customerPhone: '+91 97400 99881',
        shippingAddress: '78 Park Street, 3rd Floor, Kolkata, West Bengal 700016',
        items: [
          OrderItemModel(
            productId: 'prod_6',
            productTitle: 'FuelX Autotune Performance ECU Module',
            productSku: 'B1-EC-FX-006',
            price: 14999.0,
            quantity: 1,
            imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=500&auto=format&fit=crop&q=60',
          ),
        ],
        totalAmount: 14999.0,
        status: AppConstants.orderStatusDispatched,
        createdAt: now.subtract(const Duration(days: 1, hours: 4)),
        courierPartner: 'BlueDart Express',
        trackingId: 'BD-884920194IN',
        trackingLogs: [
          TrackingLogEntry(
            status: 'Order Placed',
            description: 'Order received',
            timestamp: now.subtract(const Duration(days: 1, hours: 4)),
          ),
          TrackingLogEntry(
            status: 'Accepted',
            description: 'Inventory verified and packed',
            timestamp: now.subtract(const Duration(days: 1, hours: 1)),
          ),
          TrackingLogEntry(
            status: 'Dispatched',
            description: 'Handed over to BlueDart Express (AWB: BD-884920194IN)',
            timestamp: now.subtract(const Duration(hours: 18)),
          ),
        ],
      ),
      OrderModel(
        id: 'ord_104',
        orderNumber: 'B1-ORD-9370',
        customerName: 'Karan Mehra',
        customerEmail: 'karan.m@example.com',
        customerPhone: '+91 99201 11223',
        shippingAddress: 'Unit 4, Industrial Estate, Andheri East, Mumbai, Maharashtra 400069',
        items: [
          OrderItemModel(
            productId: 'prod_5',
            productTitle: 'B1 CNC Foldable 6-Stage Adjustable Levers',
            productSku: 'B1-HB-LV-005',
            price: 3299.0,
            quantity: 2,
            imageUrl: 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=500&auto=format&fit=crop&q=60',
          ),
        ],
        totalAmount: 6598.0,
        status: AppConstants.orderStatusDelivered,
        createdAt: now.subtract(const Duration(days: 3)),
        courierPartner: 'Delhivery Logistics',
        trackingId: 'DLH77291044',
        trackingLogs: [
          TrackingLogEntry(
            status: 'Dispatched',
            description: 'Shipped via Delhivery',
            timestamp: now.subtract(const Duration(days: 2)),
          ),
          TrackingLogEntry(
            status: 'Delivered',
            description: 'Successfully delivered to customer',
            timestamp: now.subtract(const Duration(days: 1)),
          ),
        ],
      ),
    ];
  }
}
