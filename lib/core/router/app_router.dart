import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../session/cubit/session_cubit.dart';
import '../session/session_repository.dart';
import 'placeholder_screens.dart';
import 'routes.dart';

class AppRouter {
  AppRouter(this._session) {
    _refresh = _SessionRefresh(_session);
    router = GoRouter(
      initialLocation: Routes.splash,
      refreshListenable: _refresh,
      redirect: _redirect,
      routes: [
        GoRoute(
          path: Routes.splash,
          builder: (_, _) => const PlaceholderScreen('Loading'),
        ),
        GoRoute(
          path: Routes.auth,
          builder: (_, _) => const PlaceholderScreen('Auth'),
        ),
        GoRoute(
          path: Routes.customerHome,
          builder: (_, _) => const PlaceholderScreen('Customer app'),
        ),
        GoRoute(
          path: Routes.venueSetup,
          builder: (_, _) => const PlaceholderScreen('Venue setup'),
        ),
        GoRoute(
          path: Routes.venueHome,
          builder: (_, _) => const PlaceholderScreen('Venue app'),
        ),
      ],
    );
  }

  final SessionCubit _session;
  late final _SessionRefresh _refresh;
  late final GoRouter router;

  String? _redirect(BuildContext context, GoRouterState state) {
    final s = _session.state;
    final loc = state.matchedLocation;

    final target = switch (s) {
      SessionLoading() => Routes.splash,
      SessionSignedOut() => Routes.auth,
      SessionError() => Routes.auth,
      SessionSignedIn(:final info) => switch (info.role) {
        AccountRole.customer => Routes.customerHome,
        AccountRole.venue =>
          info.setupCompleted ? Routes.venueHome : Routes.venueSetup,
      },
    };

    // Customers stay inside /customer/*, venues inside /venue/*.
    final allowed = switch (s) {
      SessionSignedIn(:final info) when info.role == AccountRole.customer =>
        loc.startsWith(Routes.customerHome),
      SessionSignedIn(:final info) when info.setupCompleted =>
        loc.startsWith(Routes.venueHome) && loc != Routes.venueSetup,
      SessionSignedIn() => loc == Routes.venueSetup,
      SessionSignedOut() || SessionError() => loc == Routes.auth,
      SessionLoading() => loc == Routes.splash,
    };

    return allowed ? null : target;
  }

  void dispose() => _refresh.dispose();
}

class _SessionRefresh extends ChangeNotifier {
  _SessionRefresh(SessionCubit cubit) {
    _sub = cubit.stream.listen((_) => notifyListeners());
  }

  late final dynamic _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
