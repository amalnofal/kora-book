import 'package:get_it/get_it.dart';
import 'package:kora_book/core/router/app_router.dart';
import 'package:kora_book/core/session/cubit/session_cubit.dart';
import 'package:kora_book/core/session/session_repository.dart';
import 'package:kora_book/core/settings/cubit/settings_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final prefs = await SharedPreferences.getInstance();

  getIt.registerSingleton<SharedPreferences>(prefs);
  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
  getIt.registerSingleton<SettingsCubit>(SettingsCubit(prefs));

  getIt.registerSingleton<SessionRepository>(
    SessionRepository(getIt<SupabaseClient>()),
  );
  getIt.registerSingleton<SessionCubit>(
    SessionCubit(getIt<SessionRepository>()),
  );
  getIt.registerSingleton<AppRouter>(AppRouter(getIt<SessionCubit>()));
}
