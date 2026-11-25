import 'package:alvaro_pay/core/error/exceptions.dart';
import 'package:alvaro_pay/features/auth/data/models/app_user_model.dart';

// Stands in for a real backend: an in-memory "user directory" plus a
// simulated network delay, so login/sign-up behave like a real
// round-trip without needing any server for this demo.
class AuthMockDataSource {
  AuthMockDataSource({Duration? latency}) : _latency = latency ?? const Duration(milliseconds: 900);

  final Duration _latency;
  final Map<String, _StoredAccount> _accounts = <String, _StoredAccount>{};
  int _nextId = 1;

  Future<AppUserModel> login({required String email, required String password}) async {
    await Future<void>.delayed(_latency);
    final String key = email.trim().toLowerCase();
    final _StoredAccount? account = _accounts[key];
    if (account == null || account.password != password) {
      throw const ValidationException('Incorrect email or password.');
    }
    return AppUserModel(id: account.id, fullName: account.fullName, email: email);
  }

  Future<AppUserModel> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(_latency);
    final String key = email.trim().toLowerCase();
    if (_accounts.containsKey(key)) {
      throw const ValidationException('An account with this email already exists.');
    }
    final String id = 'user-${_nextId++}';
    _accounts[key] = _StoredAccount(id: id, fullName: fullName, password: password);
    return AppUserModel(id: id, fullName: fullName, email: email);
  }
}

class _StoredAccount {
  _StoredAccount({required this.id, required this.fullName, required this.password});

  final String id;
  final String fullName;
  final String password;
}
