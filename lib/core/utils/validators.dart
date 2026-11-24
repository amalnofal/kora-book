import 'package:kora_book/core/utils/phone.dart';

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

  static final _lower = RegExp(r'[a-z]');
  static final _upper = RegExp(r'[A-Z]');
  static final _digit = RegExp(r'\d');
  static final _symbol = RegExp(r'''[!@#$%^&*()_+\-=\[\]{};':"|<>?,./`~]''');

  /// Non-empty text; [message] is the localized error to return.
  static String? requiredText(String? value, String message) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? phone(String? value, AppLocalizations l10n) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return l10n.validationPhoneRequired;
    if (normalizeEgyptianMobile(text) == null) {
      return l10n.validationPhoneInvalid;
    }
    return null;
  }

  /// Sign-up / change-password rule. Mirrors the Supabase password policy:
  /// 8+ chars with lowercase, uppercase, a digit and a symbol.
  static String? newPassword(String? value, AppLocalizations l10n) {
    final text = value ?? '';
    if (text.isEmpty) return l10n.validationPasswordRequired;
    final strong =
        text.length >= 8 &&
        _lower.hasMatch(text) &&
        _upper.hasMatch(text) &&
        _digit.hasMatch(text) &&
        _symbol.hasMatch(text);
    return strong ? null : l10n.validationPasswordWeak;
  }
}
