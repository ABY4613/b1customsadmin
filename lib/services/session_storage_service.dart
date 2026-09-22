import 'dart:convert';
import '../models/user_model.dart';
import 'session_storage_stub.dart'
    if (dart.library.html) 'session_storage_web.dart';

class SessionStorageService {
  static const String _sessionKey = 'b1_customs_admin_session';

  static void saveSession(UserModel user) {
    try {
      final jsonStr = jsonEncode(user.toJson());
      saveWebSession(_sessionKey, jsonStr);
    } catch (_) {}
  }

  static UserModel? loadSession() {
    try {
      final jsonStr = loadWebSession(_sessionKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        return UserModel.fromMap(map, map['id'] ?? 'admin_restored');
      }
    } catch (_) {}
    return null;
  }

  static void clearSession() {
    try {
      clearWebSession(_sessionKey);
    } catch (_) {}
  }
}
