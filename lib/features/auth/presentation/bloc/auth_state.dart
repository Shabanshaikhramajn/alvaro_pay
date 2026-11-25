import 'package:equatable/equatable.dart';

import 'package:alvaro_pay/features/auth/domain/entities/app_user.dart';

enum AuthFormMode { login, signUp }

enum AuthStatus { idle, submitting, success, failure }

class AuthState extends Equatable {
  const AuthState({
    this.mode = AuthFormMode.login,
    this.status = AuthStatus.idle,
    this.user,
    this.errorMessage,
  });

  final AuthFormMode mode;
  final AuthStatus status;
  final AppUser? user;
  final String? errorMessage;

  bool get isLogin => mode == AuthFormMode.login;
  bool get isSubmitting => status == AuthStatus.submitting;

  AuthState copyWith({
    AuthFormMode? mode,
    AuthStatus? status,
    AppUser? user,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      mode: mode ?? this.mode,
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => <Object?>[mode, status, user, errorMessage];
}
