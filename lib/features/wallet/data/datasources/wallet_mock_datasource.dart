import 'package:alvaro_pay/core/error/exceptions.dart';
import 'package:alvaro_pay/features/wallet/data/models/wallet_model.dart';
import 'package:alvaro_pay/features/wallet/data/models/wallet_transaction_model.dart';
import 'package:alvaro_pay/features/wallet/domain/entities/wallet_transaction.dart';

// Stands in for a real backend/ledger: keeps the balance and a
// transaction history in memory for the life of the app, and simulates
// the network delay of a real transfer/purchase/bill payment.
class WalletMockDataSource {
  WalletMockDataSource({double startingBalance = 2500, Duration? latency})
    : _latency = latency ?? const Duration(milliseconds: 900),
      _balance = startingBalance;

  final Duration _latency;
  double _balance;
  final List<WalletTransactionModel> _history = <WalletTransactionModel>[];
  int _nextTransactionId = 1;

  Future<WalletModel> getWallet() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _current();
  }

  Future<WalletModel> sendMoney({required String recipient, required double amount}) => _debit(
    amount,
    type: TransactionType.sendMoney,
    counterpart: recipient,
  );

  Future<WalletModel> buyAirtime({required String phoneNumber, required double amount}) => _debit(
    amount,
    type: TransactionType.buyAirtime,
    counterpart: phoneNumber,
  );

  Future<WalletModel> payBill({
    required String biller,
    required String accountNumber,
    required double amount,
  }) =>
      _debit(amount, type: TransactionType.payBill, counterpart: biller);

  Future<List<WalletTransactionModel>> getTransactionHistory() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List<WalletTransactionModel>.unmodifiable(_history);
  }

  Future<WalletModel> _debit(
    double amount, {
    required TransactionType type,
    required String counterpart,
  }) async {
    await Future<void>.delayed(_latency);
    if (amount <= 0) {
      throw const ValidationException('Enter a valid amount.');
    }
    if (amount > _balance) {
      throw const InsufficientBalanceException('Insufficient balance.');
    }
    _balance -= amount;
    _history.insert(
      0,
      WalletTransactionModel(
        id: 'txn-${_nextTransactionId++}',
        type: type,
        counterpart: counterpart,
        amount: amount,
        timestamp: DateTime.now(),
      ),
    );
    return _current();
  }

  WalletModel _current() => WalletModel(balance: _balance, currencySymbol: '\$');
}
