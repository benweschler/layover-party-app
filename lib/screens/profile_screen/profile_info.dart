import 'package:flutter/material.dart';
import 'package:layover_party/data/app_user.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/styles/theme.dart';

class ProfileInfo extends StatelessWidget {
  final AppUser user;

  const ProfileInfo(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.of(context).secondary,
          ),
          child: Center(
            child: Text(
              user.profilePicURL?.substring(0, 3) ?? 'N',
              style: TextStyles.h2.copyWith(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: Insets.lg),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.name, style: TextStyles.body1),
            Text(
              user.email,
              style: TextStyles.body2.copyWith(
                color: AppColors.of(context).neutralContent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
