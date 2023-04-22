import 'package:flutter/material.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/styles/theme.dart';
import 'package:layover_party/widgets/loading_indicator.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

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
}
