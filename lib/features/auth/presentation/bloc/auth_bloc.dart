import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alvaro_pay/features/auth/domain/usecases/login_usecase.dart';
import 'package:alvaro_pay/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:alvaro_pay/features/auth/presentation/bloc/auth_event.dart';
import 'package:alvaro_pay/features/auth/presentation/bloc/auth_state.dart';

// Drives the single login/sign-up screen: which mode is active, the
// in-flight submit, and the resulting success/failure.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required LoginUseCase login, required SignUpUseCase signUp})
    : _login = login,
      _signUp = signUp,
      super(const AuthState()) {
    on<AuthModeToggled>(_onModeToggled);
    on<AuthLoginSubmitted>(_onLoginSubmitted);
    on<AuthSignUpSubmitted>(_onSignUpSubmitted);
  }

  final LoginUseCase _login;
  final SignUpUseCase _signUp;

  void _onModeToggled(AuthModeToggled event, Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        mode: state.isLogin ? AuthFormMode.signUp : AuthFormMode.login,
        status: AuthStatus.idle,
        clearError: true,
      ),
    );
  }

  Future<void> _onLoginSubmitted(AuthLoginSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.submitting, clearError: true));
    final result = await _login(LoginParams(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(state.copyWith(status: AuthStatus.failure, errorMessage: failure.message)),
      (user) => emit(state.copyWith(status: AuthStatus.success, user: user, clearError: true)),
    );
  }

  Future<void> _onSignUpSubmitted(AuthSignUpSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.submitting, clearError: true));
    final result = await _signUp(
      SignUpParams(fullName: event.fullName, email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(state.copyWith(status: AuthStatus.failure, errorMessage: failure.message)),
      (user) => emit(state.copyWith(status: AuthStatus.success, user: user, clearError: true)),
    );
  }
}
