class AppConfig {
  AppConfig._();

  static const appName = 'Kora Book';

  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );

  static void validate() {
    if (supabaseUrl.isEmpty || supabasePublishableKey.isEmpty) {
      throw StateError(
        'Missing SUPABASE_URL / SUPABASE_PUBLISHABLE_KEY. '
        'Run with --dart-define-from-file=env.json',
      );
    }
  }
}
