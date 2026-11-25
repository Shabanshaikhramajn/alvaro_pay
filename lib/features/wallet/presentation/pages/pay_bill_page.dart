import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alvaro_pay/core/utils/validators.dart';
import 'package:alvaro_pay/core/widgets/app_primary_button.dart';
import 'package:alvaro_pay/core/widgets/app_text_field.dart';
import 'package:alvaro_pay/core/widgets/success_sheet.dart';
import 'package:alvaro_pay/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:alvaro_pay/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:alvaro_pay/features/wallet/presentation/bloc/wallet_state.dart';
import 'package:alvaro_pay/l10n/generated/app_localizations.dart';

class PayBillPage extends StatefulWidget {
  const PayBillPage({super.key});

  @override
  State<PayBillPage> createState() => _PayBillPageState();
}

class _PayBillPageState extends State<PayBillPage> {
  final TextEditingController _billerController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _billerError;
  String? _accountError;
  String? _amountError;

  @override
  void dispose() {
    _billerController.dispose();
    _accountController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String amountText = _amountController.text.trim();
    final double? wallet = context.read<WalletBloc>().state.wallet?.balance;
    final bool isValidAmount = Validators.isValidAmount(amountText);
    final double? parsedAmount = isValidAmount ? double.parse(amountText) : null;

    setState(() {
      _billerError = _billerController.text.trim().isEmpty ? l10n.fieldRequiredError : null;
      _accountError = _accountController.text.trim().isEmpty ? l10n.fieldRequiredError : null;
      _amountError = !isValidAmount
          ? l10n.invalidAmountError
          : (wallet != null && parsedAmount != null && parsedAmount > wallet)
              ? l10n.amountExceedsBalanceError
              : null;
    });
    if (_billerError != null || _accountError != null || _amountError != null) {
      return;
    }
    context.read<WalletBloc>().add(
      WalletPayBillRequested(
        biller: _billerController.text.trim(),
        accountNumber: _accountController.text.trim(),
        amount: parsedAmount!,
      ),
    );
  }

  Future<void> _handleSuccess(BuildContext context, AppLocalizations l10n) async {
    await showSuccessSheet(
      context,
      title: l10n.successSheetTitle,
      message: l10n.payBillSuccessMessage,
    );
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.payBillsTitle)),
      body: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state.actionStatus == WalletActionStatus.success) {
            _handleSuccess(context, l10n);
          } else if (state.actionStatus == WalletActionStatus.failure &&
              state.actionMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.actionMessage!)));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                AppTextField(
                  label: l10n.billerLabel,
                  controller: _billerController,
                  errorText: _billerError,
                  prefixIcon: Icons.storefront_outlined,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: l10n.accountNumberLabel,
                  controller: _accountController,
                  errorText: _accountError,
                  prefixIcon: Icons.badge_outlined,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: l10n.amountLabel,
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  errorText: _amountError,
                  prefixIcon: Icons.payments_outlined,
                ),
                const SizedBox(height: 28),
                AppPrimaryButton(
                  label: l10n.payBillButton,
                  isLoading: state.isActionInProgress,
                  onPressed: () => _submit(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
