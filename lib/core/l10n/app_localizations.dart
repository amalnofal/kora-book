import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
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
/// import 'l10n/app_localizations.dart';
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// Label for the language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Label for the theme (light/dark) setting
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Tagline shown under the logo on the sign-in screen
  ///
  /// In en, this message translates to:
  /// **'Your next match starts here.'**
  String get authTagline;

  /// Heading of the sign-in screen
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginTitle;

  /// Subheading of the sign-in screen
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue booking'**
  String get loginSubtitle;

  /// Label of the email field
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailLabel;

  /// Placeholder of the email field
  ///
  /// In en, this message translates to:
  /// **'name@example.com'**
  String get emailHint;

  /// Label of the password field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// Link on the sign-in screen that starts password recovery
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordLink;

  /// Primary button on the sign-in screen
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInButton;

  /// Text before the create-account link on the sign-in screen
  ///
  /// In en, this message translates to:
  /// **'New to {appName}?'**
  String newToApp(String appName);

  /// Link that starts the sign-up flow
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountLink;

  /// Validation error when the email field is empty
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get validationEmailRequired;

  /// Validation error when the email format is wrong
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get validationEmailInvalid;

  /// Validation error when the password field is empty
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get validationPasswordRequired;

  /// Auth error: wrong email or password
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get authErrorInvalidCredentials;

  /// Auth error: account exists but the email is not verified
  ///
  /// In en, this message translates to:
  /// **'Please verify your email first.'**
  String get authErrorEmailNotConfirmed;

  /// Auth error: sign-up with an email that is already registered
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists.'**
  String get authErrorEmailTaken;

  /// Auth error: wrong or expired verification code
  ///
  /// In en, this message translates to:
  /// **'The code is incorrect or has expired.'**
  String get authErrorInvalidOtp;

  /// Auth error: rate limit reached
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a moment and try again.'**
  String get authErrorRateLimited;

  /// Auth error: the server rejected the password as weak
  ///
  /// In en, this message translates to:
  /// **'This password is too weak. Use at least 8 characters with uppercase, lowercase, a number and a symbol.'**
  String get authErrorWeakPassword;

  /// Auth error: new password equals the old one
  ///
  /// In en, this message translates to:
  /// **'The new password must be different from the current one.'**
  String get authErrorSamePassword;

  /// Auth error: network failure
  ///
  /// In en, this message translates to:
  /// **'No connection. Check your internet and try again.'**
  String get authErrorNetwork;

  /// Auth error: any unexpected failure
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get authErrorUnknown;

  /// Tagline on the account type screen
  ///
  /// In en, this message translates to:
  /// **'One app, built for players and football venues.'**
  String get accountTypeTagline;

  /// Heading of the account type screen
  ///
  /// In en, this message translates to:
  /// **'Choose your account'**
  String get accountTypeTitle;

  /// Subheading of the account type screen
  ///
  /// In en, this message translates to:
  /// **'This can’t be changed later. Pick the option that matches how you’ll use {appName}.'**
  String accountTypeSubtitle(String appName);

  /// Back link on the account type screen
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get accountTypeBackToSignIn;

  /// Title of the customer account option
  ///
  /// In en, this message translates to:
  /// **'Book football pitches'**
  String get accountTypeCustomerTitle;

  /// Description of the customer account option
  ///
  /// In en, this message translates to:
  /// **'Discover venues, reserve slots and manage your bookings.'**
  String get accountTypeCustomerDescription;

  /// Small badge on the customer account option
  ///
  /// In en, this message translates to:
  /// **'Customer account'**
  String get accountTypeCustomerBadge;

  /// Title of the venue account option
  ///
  /// In en, this message translates to:
  /// **'Register a football venue'**
  String get accountTypeVenueTitle;

  /// Description of the venue account option
  ///
  /// In en, this message translates to:
  /// **'Set up your venue, pitches, prices and bookings.'**
  String get accountTypeVenueDescription;

  /// Small badge on the venue account option
  ///
  /// In en, this message translates to:
  /// **'Venue account'**
  String get accountTypeVenueBadge;

  /// Generic continue button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Tagline on the customer sign-up screen
  ///
  /// In en, this message translates to:
  /// **'Create your account and get on the pitch.'**
  String get registerCustomerTagline;

  /// Tagline on the venue sign-up screen
  ///
  /// In en, this message translates to:
  /// **'Bring your venue to {appName}.'**
  String registerVenueTagline(String appName);

  /// Heading of the customer sign-up screen
  ///
  /// In en, this message translates to:
  /// **'Create customer account'**
  String get registerCustomerTitle;

  /// Heading of the venue sign-up screen
  ///
  /// In en, this message translates to:
  /// **'Create venue account'**
  String get registerVenueTitle;

  /// Subheading of the customer sign-up screen
  ///
  /// In en, this message translates to:
  /// **'A few personal details to get you started'**
  String get registerCustomerSubtitle;

  /// Subheading of the venue sign-up screen
  ///
  /// In en, this message translates to:
  /// **'Start with your venue’s basic login details'**
  String get registerVenueSubtitle;

  /// Back link on the sign-up screen
  ///
  /// In en, this message translates to:
  /// **'Change account type'**
  String get registerChangeAccountType;

  /// Step counter shown on the venue sign-up screen
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String registerStepIndicator(int current, int total);

  /// Name of the first venue sign-up step
  ///
  /// In en, this message translates to:
  /// **'Basic details'**
  String get registerStepBasicDetails;

  /// Label of the customer name field
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullNameLabel;

  /// Placeholder of the customer name field
  ///
  /// In en, this message translates to:
  /// **'Your full name'**
  String get fullNameHint;

  /// Label of the venue name field
  ///
  /// In en, this message translates to:
  /// **'Venue name'**
  String get venueNameLabel;

  /// Placeholder of the venue name field
  ///
  /// In en, this message translates to:
  /// **'Your venue’s name'**
  String get venueNameHint;

  /// Label of the phone field
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneLabel;

  /// Placeholder of the phone field (Egyptian mobile format)
  ///
  /// In en, this message translates to:
  /// **'+20 1XX XXX XXXX'**
  String get phoneHint;

  /// Helper text under the new-password field
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters, with uppercase, lowercase, a number and a symbol.'**
  String get passwordRulesHint;

  /// Checkbox the venue must tick before creating the account
  ///
  /// In en, this message translates to:
  /// **'I’m authorized to manage this venue on {appName}.'**
  String venueAuthorizationCheck(String appName);

  /// Primary button on the sign-up screen
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountButton;

  /// Text before the sign-in link on the sign-up screen
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Validation error: customer name is empty
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get validationFullNameRequired;

  /// Validation error: venue name is empty
  ///
  /// In en, this message translates to:
  /// **'Enter the venue name'**
  String get validationVenueNameRequired;

  /// Validation error: phone is empty
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get validationPhoneRequired;

  /// Validation error: phone is not a valid Egyptian mobile
  ///
  /// In en, this message translates to:
  /// **'Enter a valid Egyptian mobile number'**
  String get validationPhoneInvalid;

  /// Validation error: new password does not meet the rules
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters with uppercase, lowercase, a number and a symbol.'**
  String get validationPasswordWeak;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
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
