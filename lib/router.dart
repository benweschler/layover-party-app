import 'dart:async';

import 'package:layover_party/main_app_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:layover_party/models/trip_model.dart';
import 'package:layover_party/screens/forgot_password_screen.dart';
import 'package:layover_party/screens/login_screen/login_screen.dart';
import 'package:layover_party/screens/onboarding/onboarding_screen.dart';
import 'package:layover_party/screens/parties_screen.dart';
import 'package:layover_party/screens/profile_screen/profile_screen.dart';
import 'package:layover_party/screens/trips_screen/trips_screen.dart';
import 'package:layover_party/screens/signup_screen/signup_screen.dart';
import 'package:layover_party/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import 'models/app_model.dart';

abstract class RoutePaths {
  static String onboarding = '/onboarding';
  static String splash = '/';
  static String logIn = '/log-in';
  static String signUp = '/sign-up';
  static String forgotPassword = '/forgot-password';
  static String trips = '/trips';
  static String parties = '/parties';
  static String profile = '/profile';
}

class AppRouter {
  final AppModel appModel;
  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  final _navBarNavigatorKey = GlobalKey<NavigatorState>();

  AppRouter(this.appModel);

  GoRouter get router {
    return GoRouter(
      initialLocation: RoutePaths.trips,
      navigatorKey: _rootNavigatorKey,
      refreshListenable: appModel.routerRefreshNotifier,
      redirect: redirectNavigation,
      routes: [
        AppRoute(
          path: RoutePaths.onboarding,
          builder: (_) => const OnboardingScreenManager(),
        ),
        AppRoute(
          path: RoutePaths.splash,
          isNavBarTab: true,
          builder: (_) => const SplashScreen(),
        ),
        AppRoute(
          path: RoutePaths.logIn,
          isNavBarTab: true,
          builder: (_) => const LoginScreen(),
        ),
        AppRoute(
          path: RoutePaths.signUp,
          builder: (_) => SignUpScreen(),
        ),
        AppRoute(
          path: RoutePaths.forgotPassword,
          builder: (_) => const ForgotPasswordScreen(),
        ),
        ShellRoute(
          navigatorKey: _navBarNavigatorKey,
          builder: (_, __, child) => MainAppScaffold(body: child),
          routes: [
            AppRoute(
              path: RoutePaths.trips,
              isNavBarTab: true,
              builder: (_) => const TripsScreen(),
            ),
            AppRoute(
              path: RoutePaths.parties,
              isNavBarTab: true,
              builder: (_) => const PartiesScreen(),
            ),
            AppRoute(
              path: RoutePaths.profile,
              isNavBarTab: true,
              builder: (_) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    );
  }

  String? redirectNavigation(BuildContext context, GoRouterState state) {
    final path = state.subloc;

    if (!appModel.isLoggedIn &&
        path != RoutePaths.logIn &&
        path != RoutePaths.signUp &&
        path != RoutePaths.forgotPassword) {
      return RoutePaths.logIn;
    } else if (appModel.isLoggedIn) {
      if (!appModel.isInitialized && path != RoutePaths.splash) {
        context
            .read<TripModel>()
            .initialize(appModel.user.authToken)
            .then((_) => appModel.isInitialized = true);
        return RoutePaths.splash;
      } else if (appModel.isInitialized && path == RoutePaths.splash) {
        return RoutePaths.trips;
      }
    }

    return null;
  }
}

/// Custom GoRoute sub-class to make the router declaration easier to read.
class AppRoute extends GoRoute {
  /// Whether this route is the root route of a nav bar tab.
  ///
  /// If it is, do not use a page transition animation, meaning that switching
  /// tabs is instant.
  final bool isNavBarTab;

  AppRoute({
    required String path,
    Widget Function(GoRouterState state)? builder,
    Page Function(GoRouterState state)? pageBuilder,
    List<GoRoute> routes = const [],
    this.isNavBarTab = false,
  })  : assert((builder == null) ^ (pageBuilder == null)),
        assert(
          !(pageBuilder != null && isNavBarTab),
          'Passing a pageBuilder causes isNavBarTab to have no effect. Offending route: $path.',
        ),
        super(
          path: path,
          routes: routes,
          pageBuilder: (context, state) {
            if (pageBuilder != null) return pageBuilder(state);

            if (isNavBarTab) {
              return NoTransitionPage(
                key: state.pageKey,
                child: builder!(state),
              );
            }

            return CupertinoPage(child: builder!(state));
          },
        );
}

/// Converts a [Stream] to a [Listenable], which can then be passed as a
/// [refreshListenable] to a [GoRouter].
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
