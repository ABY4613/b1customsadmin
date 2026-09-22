class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String token;
  final String? avatarUrl;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.token,
    this.avatarUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'token': token,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> json, String docId) {
    DateTime parseDate(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
      if (value.runtimeType.toString().contains('Timestamp')) {
        return value.toDate();
      }

      return DateTime.now();
    }

    return UserModel(
      id: docId.isNotEmpty ? docId : (json['id'] ?? ''),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'Admin',
      token: json['token'] ?? '',
      avatarUrl: json['avatarUrl'],
      createdAt: parseDate(json['createdAt']),
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel.fromMap(json, json['id'] ?? '');
}


