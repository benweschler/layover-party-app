import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:layover_party/bootstrapper.dart';
import 'package:layover_party/models/app_model.dart';
import 'package:layover_party/models/trip_model.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/styles/theme.dart';
import 'package:layover_party/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';

// Use StatefulWidget; state is considered to be whether initializeApp has been
// called.
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Schedule microtask as initializing calls
    // dependOnInheritedWidgetOfExactType, which can't be called before
    // initState completes.
    scheduleMicrotask(() => initializeApp(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoadingIndicator(
          AppColors.of(context).primary,
          size: const Size.square(Insets.xl),
        ),
      ),
    );
  }

  void initializeApp(BuildContext context) async {
    try {
      await Bootstrapper(
        appModel: context.read<AppModel>(),
        tripModel: context.read<TripModel>(),
      ).run();
    } catch (error, stackTrace) {
      debugPrint('Caught initialization error: $error');
      debugPrint('Stack trace:\n$stackTrace');
      showDialog(
        context: context,
        //TODO: change to custom dialog
        builder: (_) => AlertDialog(
          title: const Text('Network Error'),
          content: const Text(
            'We\'re having trouble contacting the server. Check your '
            'network connect and click retry, and if everything looks okay, '
            'make sure to reach out to support.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                context.read<AppModel>().isLoggedIn = false;
                context.pop();
              },
              child: const Text('Back to Login'),
            ),
            ElevatedButton(
              onPressed: () async {
                context.pop();
                initialize() => initializeApp(context);
                // Don't let the user spam the retry button and send a ton of
                // api requests.
                await Future.delayed(const Duration(milliseconds: 1500));
                initialize();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
  }
}
