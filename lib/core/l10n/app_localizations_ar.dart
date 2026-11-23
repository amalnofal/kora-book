// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get language => 'اللغة';

  @override
  String get theme => 'المظهر';

  @override
  String get authTagline => 'مباراتك القادمة تبدأ من هنا.';

  @override
  String get loginTitle => 'مرحبًا بعودتك';

  @override
  String get loginSubtitle => 'سجّل الدخول لمتابعة الحجز';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get forgotPasswordLink => 'نسيت كلمة المرور؟';

  @override
  String get signInButton => 'تسجيل الدخول';

  @override
  String newToApp(String appName) {
    return 'جديد في $appName؟';
  }

  @override
  String get createAccountLink => 'إنشاء حساب';

  @override
  String get validationEmailRequired => 'أدخل بريدك الإلكتروني';

  @override
  String get validationEmailInvalid => 'أدخل بريدًا إلكترونيًا صحيحًا';

  @override
  String get validationPasswordRequired => 'أدخل كلمة المرور';

  @override
  String get authErrorInvalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get authErrorEmailNotConfirmed => 'يرجى تأكيد بريدك الإلكتروني أولًا.';

  @override
  String get authErrorEmailTaken =>
      'يوجد حساب مسجّل بهذا البريد الإلكتروني بالفعل.';

  @override
  String get authErrorInvalidOtp => 'الرمز غير صحيح أو انتهت صلاحيته.';

  @override
  String get authErrorRateLimited =>
      'محاولات كثيرة. انتظر قليلًا ثم حاول مرة أخرى.';

  @override
  String get authErrorWeakPassword =>
      'كلمة المرور ضعيفة. استخدم 8 أحرف على الأقل تشمل حرفًا إنجليزيًا كبيرًا وصغيرًا ورقمًا ورمزًا.';

  @override
  String get authErrorSamePassword =>
      'يجب أن تختلف كلمة المرور الجديدة عن الحالية.';

  @override
  String get authErrorNetwork =>
      'لا يوجد اتصال. تحقق من الإنترنت وحاول مرة أخرى.';

  @override
  String get authErrorUnknown => 'حدث خطأ ما. حاول مرة أخرى.';
}
