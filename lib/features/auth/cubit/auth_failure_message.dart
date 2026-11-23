import '../../../core/l10n/app_localizations.dart';
import '../data/models/auth_failure.dart';

/// Maps an [AuthFailure] to a localized, user-facing message.
extension AuthFailureMessage on AuthFailure {
  String message(AppLocalizations l10n) => switch (type) {
    AuthFailureType.invalidCredentials => l10n.authErrorInvalidCredentials,
    AuthFailureType.emailNotConfirmed => l10n.authErrorEmailNotConfirmed,
    AuthFailureType.emailTaken => l10n.authErrorEmailTaken,
    AuthFailureType.invalidOtp => l10n.authErrorInvalidOtp,
    AuthFailureType.rateLimited => l10n.authErrorRateLimited,
    AuthFailureType.weakPassword => l10n.authErrorWeakPassword,
    AuthFailureType.samePassword => l10n.authErrorSamePassword,
    AuthFailureType.network => l10n.authErrorNetwork,
    AuthFailureType.unknown => l10n.authErrorUnknown,
  };
}
