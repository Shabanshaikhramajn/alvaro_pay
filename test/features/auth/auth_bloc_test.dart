import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:alvaro_pay/core/error/failures.dart';
import 'package:alvaro_pay/features/auth/domain/entities/app_user.dart';
import 'package:alvaro_pay/features/auth/domain/repositories/auth_repository.dart';
import 'package:alvaro_pay/features/auth/domain/usecases/login_usecase.dart';
import 'package:alvaro_pay/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:alvaro_pay/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:alvaro_pay/features/auth/presentation/bloc/auth_event.dart';
import 'package:alvaro_pay/features/auth/presentation/bloc/auth_state.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;
  late AuthBloc bloc;

  const AppUser user = AppUser(id: 'user-1', fullName: 'Ada Lovelace', email: 'ada@example.com');

  setUp(() {
    repository = _MockAuthRepository();
    bloc = AuthBloc(login: LoginUseCase(repository), signUp: SignUpUseCase(repository));
  });

  tearDown(() => bloc.close());

  blocTest<AuthBloc, AuthState>(
    'emits submitting then success when login succeeds',
    setUp: () {
      when(
        () => repository.login(email: any(named: 'email'), password: any(named: 'password')),
      ).thenAnswer((_) async => const Right(user));
    },
    build: () => bloc,
    act: (bloc) => bloc.add(const AuthLoginSubmitted(email: 'ada@example.com', password: 'secret1')),
    expect: () => <Matcher>[
      isA<AuthState>().having((s) => s.status, 'status', AuthStatus.submitting),
      isA<AuthState>()
          .having((s) => s.status, 'status', AuthStatus.success)
          .having((s) => s.user, 'user', user),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits submitting then failure with the repository message when login fails',
    setUp: () {
      when(
        () => repository.login(email: any(named: 'email'), password: any(named: 'password')),
      ).thenAnswer((_) async => const Left(ValidationFailure('Incorrect email or password.')));
    },
    build: () => bloc,
    act: (bloc) => bloc.add(const AuthLoginSubmitted(email: 'ada@example.com', password: 'wrong')),
    expect: () => <Matcher>[
      isA<AuthState>().having((s) => s.status, 'status', AuthStatus.submitting),
      isA<AuthState>()
          .having((s) => s.status, 'status', AuthStatus.failure)
          .having((s) => s.errorMessage, 'errorMessage', 'Incorrect email or password.'),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'toggling the mode switches between login and sign up and clears errors',
    build: () => bloc,
    act: (bloc) => bloc.add(const AuthModeToggled()),
    expect: () => <Matcher>[
      isA<AuthState>().having((s) => s.mode, 'mode', AuthFormMode.signUp),
    ],
  );
}
