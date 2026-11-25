import 'package:shared_preferences/shared_preferences.dart';

import 'package:alvaro_pay/features/auth/data/models/app_user_model.dart';

// Persists "who's logged in" across app restarts using the device's
// local key-value store - just enough to skip the login screen next
// time, not a real auth token/session mechanism.
class AuthSessionLocalDataSource {
  static const String _keyId = 'alvaro_pay_session_user_id';
  static const String _keyFullName = 'alvaro_pay_session_full_name';
  static const String _keyEmail = 'alvaro_pay_session_email';

  Future<void> saveSession(AppUserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyId, user.id);
    await prefs.setString(_keyFullName, user.fullName);
    await prefs.setString(_keyEmail, user.email);
  }

  Future<AppUserModel?> loadSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = prefs.getString(_keyId);
    final String? fullName = prefs.getString(_keyFullName);
    final String? email = prefs.getString(_keyEmail);
    if (id == null || fullName == null || email == null) {
      return null;
    }
    return AppUserModel(id: id, fullName: fullName, email: email);
  }

  Future<void> clearSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyId);
    await prefs.remove(_keyFullName);
    await prefs.remove(_keyEmail);
  }
}
