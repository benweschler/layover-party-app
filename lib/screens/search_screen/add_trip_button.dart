import 'package:flutter/material.dart';
import 'package:layover_party/widgets/folding_ticket/ticket_segment.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/widgets/buttons/responsive_buttons.dart';

class AddTripButton extends StatelessWidget implements TicketSegment {
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
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Corners.smRadius,
          bottomRight: Corners.smRadius,
        ),
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
