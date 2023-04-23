import 'package:flutter/material.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/widgets/buttons/responsive_buttons.dart';

class AddTripButton extends StatelessWidget implements PreferredSizeWidget {
  final GestureTapCallback onTap;

  const AddTripButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(
        vertical: Insets.sm,
        horizontal: Insets.lg,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Corners.smRadius,
          bottomRight: Corners.smRadius,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ResponsiveButton.large(
        onTap: onTap,
        builder: (_) => Container(
          padding: const EdgeInsets.symmetric(vertical: Insets.sm),
          decoration: const ShapeDecoration(
            shape: StadiumBorder(),
            color: Colors.black,
          ),
          child: Center(
            child: Text(
              'Go on Trip',
              style: TextStyles.body2.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(65);
}
