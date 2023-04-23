import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:layover_party/models/app_model.dart';
import 'package:layover_party/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:layover_party/styles/theme.dart';

import 'models/trip_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Remove '#' from web URL.
  usePathUrlStrategy();

  final tripModel = TripModel();
  final appModel = AppModel(tripModel);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: appModel),
      ChangeNotifierProvider.value(value: tripModel),
    ],
    child: MyApp(AppRouter(appModel).router),
  ));
}

class MyApp extends StatelessWidget {
  final RouterConfig<Object> router;

  const MyApp(this.router, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: _resolveIsDark(context)
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: MaterialApp.router(
        title: 'layover_party',
        debugShowCheckedModeBanner: false,
        theme: AppColors.fromType(
          context.select<AppModel, ThemeType>((model) => model.lightThemeType),
        ).toThemeData(),
        darkTheme: AppColors.fromType(
          context.select<AppModel, ThemeType>((model) => model.darkThemeType),
        ).toThemeData(),
        routerConfig: router,
      ),
    );
  }

  /// Whether the app's current theme is dark.
  bool _resolveIsDark(BuildContext context) {
    switch (context.read<AppModel>().themeMode) {
      case ThemeMode.system:
        return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
      case ThemeMode.light:
        return false;
      case ThemeMode.dark:
        return true;
    }
  }
}
