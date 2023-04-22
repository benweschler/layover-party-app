import 'package:flutter/material.dart' show ThemeMode;
import 'package:layover_party/data/app_user.dart';
import 'package:layover_party/styles/theme.dart';
import 'package:layover_party/utils/easy_notifier.dart';

class AppModel extends EasyNotifier {
  final EasyNotifier routerRefreshNotifier = EasyNotifier();

  /// The user that is currently signed in.
  AppUser? _user;

  /// Whether a user is logged into the app.
  bool _isLoggedIn = false;

  /// Whether the app has been initialized with user data.
  bool _isInitialized = false;

  /// The active theme for the app.
  ThemeMode _themeMode = ThemeMode.light;

  AppUser get user {
    if (_user == null) {
      throw Exception('The user was accessed when no user is logged in.');
    }

    return _user!;
  }

  set user(AppUser? user) => notify(() => _user = user);

  ThemeMode get themeMode => _themeMode;

  set themeMode(themeMode) => notify(() => _themeMode = themeMode);

  ThemeType get lightThemeType {
    if (themeMode == ThemeMode.dark) return ThemeType.dark;
    return ThemeType.light;
  }

  ThemeType get darkThemeType {
    if (themeMode == ThemeMode.light) return ThemeType.light;
    return ThemeType.dark;
  }

  bool get isLoggedIn => _isLoggedIn;

  set isLoggedIn(bool value) {
    if(value == false) {
      _user = null;
      _isInitialized = false;
    }

    routerRefreshNotifier.notify(() => _isLoggedIn = value);
  }

  bool get isInitialized => _isInitialized;

  set isInitialized(bool value) =>
      routerRefreshNotifier.notify(() => _isInitialized = value);
}
