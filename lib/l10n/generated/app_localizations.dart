import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Alvaro Pay'**
  String get appName;

  /// No description provided for @loginWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginWelcomeTitle;

  /// No description provided for @loginWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to continue to your wallet'**
  String get loginWelcomeSubtitle;

  /// No description provided for @signUpWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get signUpWelcomeTitle;

  /// No description provided for @signUpWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up to start using Alvaro Pay'**
  String get signUpWelcomeSubtitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullNameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginButton;

  /// No description provided for @signUpButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get signUpButton;

  /// No description provided for @switchToSignUpPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get switchToSignUpPrompt;

  /// No description provided for @switchToSignUpAction.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get switchToSignUpAction;

  /// No description provided for @switchToLoginPrompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get switchToLoginPrompt;

  /// No description provided for @switchToLoginAction.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get switchToLoginAction;

  /// No description provided for @fieldRequiredError.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequiredError;

  /// No description provided for @invalidEmailError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get invalidEmailError;

  /// No description provided for @passwordTooShortError.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShortError;

  /// No description provided for @passwordMismatchError.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get passwordMismatchError;

  /// No description provided for @loginSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get loginSuccessMessage;

  /// No description provided for @signUpSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Account created! You\'re all set.'**
  String get signUpSuccessMessage;

  /// No description provided for @walletHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'My Wallet'**
  String get walletHomeTitle;

  /// No description provided for @availableBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Available balance'**
  String get availableBalanceLabel;

  /// No description provided for @hideBalanceTooltip.
  ///
  /// In en, this message translates to:
  /// **'Hide balance'**
  String get hideBalanceTooltip;

  /// No description provided for @showBalanceTooltip.
  ///
  /// In en, this message translates to:
  /// **'Show balance'**
  String get showBalanceTooltip;

  /// No description provided for @quickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActionsTitle;

  /// No description provided for @sendMoneyAction.
  ///
  /// In en, this message translates to:
  /// **'Send Money'**
  String get sendMoneyAction;

  /// No description provided for @buyAirtimeAction.
  ///
  /// In en, this message translates to:
  /// **'Buy Airtime/Data'**
  String get buyAirtimeAction;

  /// No description provided for @payBillsAction.
  ///
  /// In en, this message translates to:
  /// **'Pay Bills'**
  String get payBillsAction;

  /// No description provided for @logoutTooltip.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutTooltip;

  /// No description provided for @sendMoneyTitle.
  ///
  /// In en, this message translates to:
  /// **'Send Money'**
  String get sendMoneyTitle;

  /// No description provided for @recipientLabel.
  ///
  /// In en, this message translates to:
  /// **'Recipient (phone or email)'**
  String get recipientLabel;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @sendMoneyButton.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get sendMoneyButton;

  /// No description provided for @sendMoneySuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Money sent successfully'**
  String get sendMoneySuccessMessage;

  /// No description provided for @invalidAmountError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get invalidAmountError;

  /// No description provided for @buyAirtimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Buy Airtime/Data'**
  String get buyAirtimeTitle;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumberLabel;

  /// No description provided for @buyAirtimeButton.
  ///
  /// In en, this message translates to:
  /// **'Buy now'**
  String get buyAirtimeButton;

  /// No description provided for @buyAirtimeSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Airtime/data purchase successful'**
  String get buyAirtimeSuccessMessage;

  /// No description provided for @payBillsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pay Bills'**
  String get payBillsTitle;

  /// No description provided for @billerLabel.
  ///
  /// In en, this message translates to:
  /// **'Biller'**
  String get billerLabel;

  /// No description provided for @accountNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Account / meter number'**
  String get accountNumberLabel;

  /// No description provided for @payBillButton.
  ///
  /// In en, this message translates to:
  /// **'Pay bill'**
  String get payBillButton;

  /// No description provided for @payBillSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Bill paid successfully'**
  String get payBillSuccessMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
