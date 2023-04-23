import 'package:flutter/material.dart';
import 'package:layover_party/styles/theme.dart';

class CustomDivider extends StatelessWidget {
  final Color? color;

  const CustomDivider({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      width: double.infinity,
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        color: color ?? AppColors.of(context).dividerColor,
      ),
    );
  }
}

