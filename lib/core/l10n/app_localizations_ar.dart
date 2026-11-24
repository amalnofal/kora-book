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

  @override
  String get accountTypeTagline =>
      'تطبيق واحد للّاعبين وأصحاب منشآت كرة القدم.';

  @override
  String get accountTypeTitle => 'اختر نوع حسابك';

  @override
  String accountTypeSubtitle(String appName) {
    return 'لا يمكن تغييره لاحقًا. اختر ما يناسب طريقة استخدامك لـ $appName.';
  }

  @override
  String get accountTypeBackToSignIn => 'العودة لتسجيل الدخول';

  @override
  String get accountTypeCustomerTitle => 'احجز ملاعب كرة القدم';

  @override
  String get accountTypeCustomerDescription =>
      'اكتشف المنشآت، واحجز المواعيد، وأدِر حجوزاتك.';

  @override
  String get accountTypeCustomerBadge => 'حساب عميل';

  @override
  String get accountTypeVenueTitle => 'سجّل منشأة كرة قدم';

  @override
  String get accountTypeVenueDescription =>
      'أعدّ منشأتك وملاعبك وأسعارك وتابع الحجوزات.';

  @override
  String get accountTypeVenueBadge => 'حساب منشأة';

  @override
  String get continueButton => 'متابعة';

  @override
  String get registerCustomerTagline => 'أنشئ حسابك وادخل الملعب.';

  @override
  String registerVenueTagline(String appName) {
    return 'اعرض منشأتك على $appName.';
  }

  @override
  String get registerCustomerTitle => 'إنشاء حساب عميل';

  @override
  String get registerVenueTitle => 'إنشاء حساب منشأة';

  @override
  String get registerCustomerSubtitle => 'بعض البيانات الشخصية لنبدأ';

  @override
  String get registerVenueSubtitle => 'ابدأ ببيانات الدخول الأساسية لمنشأتك';

  @override
  String get registerChangeAccountType => 'تغيير نوع الحساب';

  @override
  String registerStepIndicator(int current, int total) {
    return 'الخطوة $current من $total';
  }

  @override
  String get registerStepBasicDetails => 'البيانات الأساسية';

  @override
  String get fullNameLabel => 'الاسم الكامل';

  @override
  String get fullNameHint => 'اكتب اسمك الكامل';

  @override
  String get venueNameLabel => 'اسم المنشأة';

  @override
  String get venueNameHint => 'اكتب اسم منشأتك';

  @override
  String get phoneLabel => 'رقم الهاتف';

  @override
  String get phoneHint => '+20 1XX XXX XXXX';

  @override
  String get passwordRulesHint =>
      '8 أحرف على الأقل، وتشمل حرفًا إنجليزيًا كبيرًا وصغيرًا ورقمًا ورمزًا.';

  @override
  String venueAuthorizationCheck(String appName) {
    return 'أُقرّ بأنني مخوّل بإدارة هذه المنشأة على $appName.';
  }

  @override
  String get createAccountButton => 'إنشاء الحساب';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get validationFullNameRequired => 'أدخل اسمك الكامل';

  @override
  String get validationVenueNameRequired => 'أدخل اسم المنشأة';

  @override
  String get validationPhoneRequired => 'أدخل رقم هاتفك';

  @override
  String get validationPhoneInvalid => 'أدخل رقم موبايل مصري صحيح';

  @override
  String get validationPasswordWeak =>
      'استخدم 8 أحرف على الأقل تشمل حرفًا إنجليزيًا كبيرًا وصغيرًا ورقمًا ورمزًا.';
}
