import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'buttons/responsive_buttons.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveStrokeButton(
      onTap: context.pop,
      child: const Icon(Icons.arrow_back_ios_new_rounded),
    );
  }
}
