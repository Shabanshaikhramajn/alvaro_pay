import 'package:alvaro_pay/features/wallet/domain/entities/wallet.dart';

class WalletModel extends Wallet {
  const WalletModel({required super.balance, required super.currencySymbol});

  factory WalletModel.fromEntity(Wallet wallet) {
    return WalletModel(balance: wallet.balance, currencySymbol: wallet.currencySymbol);
  }
}
