// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get authTagline => 'Your next match starts here.';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to continue booking';

  @override
  String get emailLabel => 'Email address';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get forgotPasswordLink => 'Forgot password?';

  @override
  String get signInButton => 'Sign in';

  @override
  String newToApp(String appName) {
    return 'New to $appName?';
  }

  @override
  String get createAccountLink => 'Create account';

  @override
  String get validationEmailRequired => 'Enter your email';

  @override
  String get validationEmailInvalid => 'Enter a valid email address';

  @override
  String get validationPasswordRequired => 'Enter your password';

  @override
  String get authErrorInvalidCredentials => 'Incorrect email or password.';

  @override
  String get authErrorEmailNotConfirmed => 'Please verify your email first.';

  @override
  String get authErrorEmailTaken =>
      'An account with this email already exists.';

  @override
  String get authErrorInvalidOtp => 'The code is incorrect or has expired.';

  @override
  String get authErrorRateLimited =>
      'Too many attempts. Please wait a moment and try again.';

  @override
  String get authErrorWeakPassword =>
      'This password is too weak. Use at least 8 characters with uppercase, lowercase, a number and a symbol.';

  @override
  String get authErrorSamePassword =>
      'The new password must be different from the current one.';

  @override
  String get authErrorNetwork =>
      'No connection. Check your internet and try again.';

  @override
  String get authErrorUnknown => 'Something went wrong. Please try again.';

  @override
  String get accountTypeTagline =>
      'One app, built for players and football venues.';

  @override
  String get accountTypeTitle => 'Choose your account';

  @override
  String accountTypeSubtitle(String appName) {
    return 'This can’t be changed later. Pick the option that matches how you’ll use $appName.';
  }

  @override
  String get accountTypeBackToSignIn => 'Back to sign in';

  @override
  String get accountTypeCustomerTitle => 'Book football pitches';

  @override
  String get accountTypeCustomerDescription =>
      'Discover venues, reserve slots and manage your bookings.';

  @override
  String get accountTypeCustomerBadge => 'Customer account';

  @override
  String get accountTypeVenueTitle => 'Register a football venue';

  @override
  String get accountTypeVenueDescription =>
      'Set up your venue, pitches, prices and bookings.';

  @override
  String get accountTypeVenueBadge => 'Venue account';

  @override
  String get continueButton => 'Continue';

  @override
  String get registerCustomerTagline =>
      'Create your account and get on the pitch.';

  @override
  String registerVenueTagline(String appName) {
    return 'Bring your venue to $appName.';
  }

  @override
  String get registerCustomerTitle => 'Create customer account';

  @override
  String get registerVenueTitle => 'Create venue account';

  @override
  String get registerCustomerSubtitle =>
      'A few personal details to get you started';

  @override
  String get registerVenueSubtitle =>
      'Start with your venue’s basic login details';

  @override
  String get registerChangeAccountType => 'Change account type';

  @override
  String registerStepIndicator(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get registerStepBasicDetails => 'Basic details';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get fullNameHint => 'Your full name';

  @override
  String get venueNameLabel => 'Venue name';

  @override
  String get venueNameHint => 'Your venue’s name';

  @override
  String get phoneLabel => 'Phone number';

  @override
  String get phoneHint => '+20 1XX XXX XXXX';

  @override
  String get passwordRulesHint =>
      'At least 8 characters, with uppercase, lowercase, a number and a symbol.';

  @override
  String venueAuthorizationCheck(String appName) {
    return 'I’m authorized to manage this venue on $appName.';
  }

  @override
  String get createAccountButton => 'Create account';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get validationFullNameRequired => 'Enter your full name';

  @override
  String get validationVenueNameRequired => 'Enter the venue name';

  @override
  String get validationPhoneRequired => 'Enter your phone number';

  @override
  String get validationPhoneInvalid => 'Enter a valid Egyptian mobile number';

  @override
  String get validationPasswordWeak =>
      'Use at least 8 characters with uppercase, lowercase, a number and a symbol.';
}
