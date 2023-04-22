import 'package:flutter/material.dart';
import 'package:layover_party/models/app_model.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.read<AppModel>().isLoggedIn = true,
          child: const Text('Login'),
        ),
      ),
    );
  }
}
