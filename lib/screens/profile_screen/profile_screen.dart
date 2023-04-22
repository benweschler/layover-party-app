import 'package:flutter/material.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/utils/iterable_utils.dart';
import 'package:layover_party/widgets/custom_scaffold.dart';

import 'change_theme_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: ListView(
        children: [
          const Text('Profile'),
          const SizedBox(height: Insets.lg),
          Row(
            children: <Widget>[
              const Expanded(
                child: ChangeThemeButton(themeMode: ThemeMode.light),
              ),
              const Expanded(
                child: ChangeThemeButton(themeMode: ThemeMode.dark),
              ),
              const Expanded(
                child: ChangeThemeButton(themeMode: ThemeMode.system),
              ),
            ].separate(const SizedBox(width: Insets.sm)).toList(),
          ),
        ],
      ),
    );
  }
}
