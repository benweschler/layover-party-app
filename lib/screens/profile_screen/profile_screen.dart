import 'package:flutter/material.dart';
import 'package:layover_party/constants.dart';
import 'package:layover_party/models/app_model.dart';
import 'package:layover_party/screens/profile_screen/profile_info.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/utils/iterable_utils.dart';
import 'package:layover_party/widgets/buttons/responsive_buttons.dart';
import 'package:layover_party/widgets/custom_scaffold.dart';
import 'package:provider/provider.dart';

import 'change_theme_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: ListView(
        children: [
          const Text('Profile', style: TextStyles.h2),
          const SizedBox(height: Insets.sm),
          ProfileInfo(context.read<AppModel>().user),
          const SizedBox(height: Insets.xl),
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
          const SizedBox(height: Insets.xl),
          const Divider(height: 0.5, thickness: 0.5),
          const SizedBox(height: Insets.xl),
          ResponsiveStrokeButton(
            onTap: () => showLicensePage(
              applicationName: 'Layover Party',
              applicationVersion: Constants.version,
              context: context,
              useRootNavigator: true,
            ),
            child: const Text(
              'About Layover Party',
              style: TextStyles.body1,
            ),
          ),
          const SizedBox(height: Insets.med),
          ResponsiveStrokeButton(
            onTap: () => context.read<AppModel>().isLoggedIn = false,
            child: const Text('Log Out', style: TextStyles.body1),
          ),
          const SizedBox(height: Insets.lg),
          Text(
            'v${Constants.version} — ${Constants.appEpithet}',
            style: TextStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: Insets.lg),
        ],
      ),
    );
  }
}
