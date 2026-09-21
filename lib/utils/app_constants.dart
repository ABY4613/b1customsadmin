class AppConstants {
  static const String appName = 'B1 Customs';
  static const String appSubTitle = 'Performance Bike Accessories Admin';
  static const String appVersion = 'v2.4.0-PROD';

  // API Endpoints & Contracts (Mock API Configuration)
  static const String apiBaseUrl = 'https://api.b1customs.com/v1/admin';
  static const String authEndpoint = '$apiBaseUrl/auth';
  static const String productsEndpoint = '$apiBaseUrl/products';
  static const String ordersEndpoint = '$apiBaseUrl/orders';
  static const String statsEndpoint = '$apiBaseUrl/stats';

  static const String authTokenKey = 'b1_admin_auth_token';

  // Product Categories
  static const List<String> productCategories = [
    'All Categories',
    'Exhaust',
    'Filters',
    'Bend Pipes',
    'Crash Guards',
    'Handlebars & Levers',
    'Performance ECU',
    'Brake Systems',
  ];

  // Order Status Lifecycles
  static const String orderStatusPending = 'Pending';
  static const String orderStatusAccepted = 'Accepted';
  static const String orderStatusDispatched = 'Dispatched';
  static const String orderStatusDelivered = 'Delivered';
  static const String orderStatusRejected = 'Rejected';

  static const List<String> orderStatuses = [
    'All Statuses',
    orderStatusPending,
    orderStatusAccepted,
    orderStatusDispatched,
    orderStatusDelivered,
    orderStatusRejected,
  ];

  // Courier Partners
  static const List<String> courierPartners = [
    'BlueDart Express',
    'Delhivery Logistics',
    'DHL Express',
    'FedEx Cargo',
    'Shadowfax Super',
    'DTDC Premium',
  ];

  // Low stock threshold
  static const int lowStockThreshold = 10;
}
