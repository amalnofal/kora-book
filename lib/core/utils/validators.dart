import '../l10n/app_localizations.dart';

/// Form validators. Each returns a localized error message, or null if valid.
class Validators {
  Validators._();

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? email(String? value, AppLocalizations l10n) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return l10n.validationEmailRequired;
    if (!_emailPattern.hasMatch(text)) return l10n.validationEmailInvalid;
    return null;
  }

  /// For sign-in only: any non-empty password. The strength rules apply
  /// at sign-up / change-password, never when logging in.
  static String? passwordRequired(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) return l10n.validationPasswordRequired;
    return null;
  }
}
