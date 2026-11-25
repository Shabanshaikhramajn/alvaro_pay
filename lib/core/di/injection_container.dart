import 'package:get_it/get_it.dart';

import 'package:alvaro_pay/features/auth/data/datasources/auth_mock_datasource.dart';
import 'package:alvaro_pay/features/auth/data/datasources/auth_session_local_datasource.dart';
import 'package:alvaro_pay/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:alvaro_pay/features/auth/domain/repositories/auth_repository.dart';
import 'package:alvaro_pay/features/auth/domain/usecases/clear_session_usecase.dart';
import 'package:alvaro_pay/features/auth/domain/usecases/get_cached_session_usecase.dart';
import 'package:alvaro_pay/features/auth/domain/usecases/login_usecase.dart';
import 'package:alvaro_pay/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:alvaro_pay/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:alvaro_pay/features/wallet/data/datasources/wallet_mock_datasource.dart';
import 'package:alvaro_pay/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:alvaro_pay/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:alvaro_pay/features/wallet/domain/usecases/buy_airtime_usecase.dart';
import 'package:alvaro_pay/features/wallet/domain/usecases/get_transaction_history_usecase.dart';
import 'package:alvaro_pay/features/wallet/domain/usecases/get_wallet_usecase.dart';
import 'package:alvaro_pay/features/wallet/domain/usecases/pay_bill_usecase.dart';
import 'package:alvaro_pay/features/wallet/domain/usecases/send_money_usecase.dart';
import 'package:alvaro_pay/features/wallet/presentation/bloc/wallet_bloc.dart';

// The app's one service locator. Blocs are factories (a fresh instance
// per screen); data sources, repositories and use cases are lazy
// singletons so the mock wallet balance survives navigation.
final GetIt sl = GetIt.instance;

void setupInjection() {
  // Auth
  sl.registerLazySingleton<AuthMockDataSource>(() => AuthMockDataSource());
  sl.registerLazySingleton<AuthSessionLocalDataSource>(() => AuthSessionLocalDataSource());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
  sl.registerLazySingleton<SignUpUseCase>(() => SignUpUseCase(sl()));
  sl.registerLazySingleton<GetCachedSessionUseCase>(() => GetCachedSessionUseCase(sl()));
  sl.registerLazySingleton<ClearSessionUseCase>(() => ClearSessionUseCase(sl()));
  sl.registerFactory<AuthBloc>(() => AuthBloc(login: sl(), signUp: sl()));

  // Wallet
  sl.registerLazySingleton<WalletMockDataSource>(() => WalletMockDataSource());
  sl.registerLazySingleton<WalletRepository>(() => WalletRepositoryImpl(sl()));
  sl.registerLazySingleton<GetWalletUseCase>(() => GetWalletUseCase(sl()));
  sl.registerLazySingleton<GetTransactionHistoryUseCase>(() => GetTransactionHistoryUseCase(sl()));
  sl.registerLazySingleton<SendMoneyUseCase>(() => SendMoneyUseCase(sl()));
  sl.registerLazySingleton<BuyAirtimeUseCase>(() => BuyAirtimeUseCase(sl()));
  sl.registerLazySingleton<PayBillUseCase>(() => PayBillUseCase(sl()));
  sl.registerFactory<WalletBloc>(
    () => WalletBloc(
      getWallet: sl(),
      getTransactionHistory: sl(),
      sendMoney: sl(),
      buyAirtime: sl(),
      payBill: sl(),
    ),
  );
}
