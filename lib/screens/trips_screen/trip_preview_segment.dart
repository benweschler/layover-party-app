import 'package:flutter/material.dart';
import 'package:layover_party/data/trip/trip.dart';
import 'package:layover_party/widgets/folding_ticket/ticket_segment.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/styles/theme.dart';
import 'package:layover_party/utils/stat_utils.dart';
import 'package:layover_party/widgets/custom_divider.dart';

import 'animated_plane_path.dart';
import 'local_theme.dart';

class TripSummarySegment extends StatelessWidget implements TicketSegment {
  final Trip trip;
  final bool isPreviewSegment;

  const TripSummarySegment(
    this.trip, {
    Key? key,
    required this.isPreviewSegment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headingStyle = TextStyles.h2.copyWith(
      fontSize: 24,
      color: isPreviewSegment ? AppColors.of(context).primary : Colors.white,
      fontWeight: FontWeight.w600,
    );
    final unitStyle = TextStyles.title.copyWith(
      color: isPreviewSegment ? AppColors.of(context).primary : Colors.white,
    );
    final captionStyle = TextStyles.caption.copyWith(
      color: isPreviewSegment
          ? AppColors.of(context).neutralContent
          : AppColors.of(context).neutralOnContainer,
    );

    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(
        vertical: Insets.xs,
        horizontal: Insets.lg,
      ),
      decoration: BoxDecoration(
        gradient: isPreviewSegment ? null : LocalTheme.gradient,
        color: isPreviewSegment ? Colors.white : null,
        borderRadius: Corners.smBorderRadius,
      ),
      child: Column(
        children: [
          const SizedBox(height: Insets.xs),
          Text(
            trip.airline.toUpperCase(),
            style: TextStyles.caption.copyWith(
              color: isPreviewSegment
                  ? AppColors.of(context).secondary
                  : Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: Insets.xs),
          CustomDivider(
            color: isPreviewSegment
                ? null
                : AppColors.of(context).dividerOnContainer,
          ),
          const SizedBox(height: Insets.sm),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text.rich(TextSpan(
                      children: formatDuration(
                        duration: trip.layovers
                            .map((layover) => layover.duration)
                            .fold(
                              Duration.zero,
                              (duration, element) => Duration(
                                  minutes:
                                      duration.inMinutes + element.inMinutes),
                            ),
                        digitStyle: headingStyle,
                        unitStyle: unitStyle,
                      ),
                    )),
                    Text("Total Layover", style: captionStyle),
                  ],
                ),
              ),
              AnimatedPlanePath(isDark: isPreviewSegment, isOpen: true),
              Expanded(
                child: Column(
                  children: [
                    Text('${trip.totalUsers}', style: headingStyle),
                    Text("Total Partiers", style: captionStyle),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Insets.xs),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: isPreviewSegment
                ? AppColors.of(context).secondary
                : Colors.white.withOpacity(0.6),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(147);
}
