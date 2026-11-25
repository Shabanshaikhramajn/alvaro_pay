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

class BuyAirtimePage extends StatefulWidget {
  const BuyAirtimePage({super.key});

  @override
  State<BuyAirtimePage> createState() => _BuyAirtimePageState();
}

class _BuyAirtimePageState extends State<BuyAirtimePage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _phoneError;
  String? _amountError;

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String phone = _phoneController.text.trim();
    final String amountText = _amountController.text.trim();
    final double? wallet = context.read<WalletBloc>().state.wallet?.balance;
    final bool isValidAmount = Validators.isValidAmount(amountText);
    final double? parsedAmount = isValidAmount ? double.parse(amountText) : null;

    setState(() {
      _phoneError = phone.isEmpty
          ? l10n.fieldRequiredError
          : !Validators.isValidPhoneNumber(phone)
              ? l10n.invalidPhoneError
              : null;
      _amountError = !isValidAmount
          ? l10n.invalidAmountError
          : (wallet != null && parsedAmount != null && parsedAmount > wallet)
              ? l10n.amountExceedsBalanceError
              : null;
    });
    if (_phoneError != null || _amountError != null) {
      return;
    }
    context.read<WalletBloc>().add(
      WalletBuyAirtimeRequested(phoneNumber: phone, amount: parsedAmount!),
    );
  }

  Future<void> _handleSuccess(BuildContext context, AppLocalizations l10n) async {
    await showSuccessSheet(
      context,
      title: l10n.successSheetTitle,
      message: l10n.buyAirtimeSuccessMessage,
    );
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.buyAirtimeTitle)),
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
                  label: l10n.phoneNumberLabel,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  errorText: _phoneError,
                  prefixIcon: Icons.phone_iphone_rounded,
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
                  label: l10n.buyAirtimeButton,
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
