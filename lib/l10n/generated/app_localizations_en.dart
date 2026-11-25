// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Alvaro Pay';

  @override
  String get loginWelcomeTitle => 'Welcome back';

  @override
  String get loginWelcomeSubtitle => 'Log in to continue to your wallet';

  @override
  String get signUpWelcomeTitle => 'Create your account';

  @override
  String get signUpWelcomeSubtitle => 'Sign up to start using Alvaro Pay';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get emailLabel => 'Email address';

  @override
  String get passwordLabel => 'Password';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get loginButton => 'Log in';

  @override
  String get signUpButton => 'Create account';

  @override
  String get switchToSignUpPrompt => 'Don\'t have an account?';

  @override
  String get switchToSignUpAction => 'Sign up';

  @override
  String get switchToLoginPrompt => 'Already have an account?';

  @override
  String get switchToLoginAction => 'Log in';

  @override
  String get fieldRequiredError => 'This field is required';

  @override
  String get invalidEmailError => 'Enter a valid email address';

  @override
  String get passwordTooShortError => 'Password must be at least 6 characters';

  @override
  String get passwordMismatchError => 'Passwords don\'t match';

  @override
  String get loginSuccessMessage => 'Welcome back!';

  @override
  String get signUpSuccessMessage => 'Account created! You\'re all set.';

  @override
  String get walletHomeTitle => 'My Wallet';

  @override
  String get availableBalanceLabel => 'Available balance';

  @override
  String get hideBalanceTooltip => 'Hide balance';

  @override
  String get showBalanceTooltip => 'Show balance';

  @override
  String get quickActionsTitle => 'Quick actions';

  @override
  String get sendMoneyAction => 'Send Money';

  @override
  String get buyAirtimeAction => 'Buy Airtime/Data';

  @override
  String get payBillsAction => 'Pay Bills';

  @override
  String get logoutTooltip => 'Log out';

  @override
  String get sendMoneyTitle => 'Send Money';

  @override
  String get recipientLabel => 'Recipient (phone or email)';

  @override
  String get amountLabel => 'Amount';

  @override
  String get sendMoneyButton => 'Send';

  @override
  String get sendMoneySuccessMessage => 'Money sent successfully';

  @override
  String get invalidAmountError => 'Enter a valid amount';

  @override
  String get buyAirtimeTitle => 'Buy Airtime/Data';

  @override
  String get phoneNumberLabel => 'Phone number';

  @override
  String get buyAirtimeButton => 'Buy now';

  @override
  String get buyAirtimeSuccessMessage => 'Airtime/data purchase successful';

  @override
  String get payBillsTitle => 'Pay Bills';

  @override
  String get billerLabel => 'Biller';

  @override
  String get accountNumberLabel => 'Account / meter number';

  @override
  String get payBillButton => 'Pay bill';

  @override
  String get payBillSuccessMessage => 'Bill paid successfully';
}
