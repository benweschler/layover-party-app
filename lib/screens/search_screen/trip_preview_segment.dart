import 'package:flutter/material.dart';
import 'package:layover_party/data/trip/trip.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/styles/theme.dart';
import 'package:layover_party/utils/stat_utils.dart';
import 'package:layover_party/widgets/custom_divider.dart';

import 'animated_plane_path.dart';
import 'local_theme.dart';

class TripSummarySegment extends StatelessWidget {
  final Trip trip;
  final bool isDark;

  const TripSummarySegment(this.trip, {Key? key, required this.isDark})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headingStyle = TextStyles.h2.copyWith(
      fontSize: 24,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );
    final unitStyle = TextStyles.title.copyWith(color: Colors.white);
    final captionStyle = TextStyles.caption.copyWith(
      color: AppColors.of(context).neutralOnContainer,
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Insets.xs,
        horizontal: Insets.lg,
      ),
      decoration: BoxDecoration(
        gradient: LocalTheme.gradient,
        borderRadius: const BorderRadius.only(
          topLeft: Corners.smRadius,
          topRight: Corners.smRadius,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            trip.airline.toUpperCase(),
            style: TextStyles.caption.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: Insets.xs),
          CustomDivider(color: AppColors.of(context).dividerOnContainer),
          const SizedBox(height: Insets.sm),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text.rich(TextSpan(
                      children: formatDuration(
                        duration: const Duration(hours: 40, minutes: 15),
                        digitStyle: headingStyle,
                        unitStyle: unitStyle,
                      ),
                    )),
                    Text("Total Layover", style: captionStyle),
                  ],
                ),
              ),
              const AnimatedPlanePath(isDark: true, isOpen: true),
              Expanded(
                child: Column(
                  children: [
                    Text.rich(TextSpan(children: [
                      TextSpan(text: '1.4', style: headingStyle),
                      TextSpan(text: 'K', style: unitStyle),
                    ])),
                    Text("Total Partiers", style: captionStyle),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Insets.xs),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white.withOpacity(0.6),
          ),
        ],
      ),
    );
  }
}
