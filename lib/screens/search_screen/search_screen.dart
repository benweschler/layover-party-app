import 'package:flutter/material.dart';
import 'package:layover_party/constants.dart';
import 'package:layover_party/screens/search_screen/local_theme.dart';
import 'package:layover_party/widgets/custom_scaffold.dart';
import 'package:layover_party/widgets/folding_ticket/ticket_segment.dart';
import 'package:layover_party/screens/search_screen/trip_details_segment.dart';
import 'package:layover_party/screens/search_screen/trip_preview_segment.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/styles/theme.dart';
import 'package:layover_party/widgets/folding_ticket/ticket.dart';

import 'add_trip_button.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TicketSegment> firstSegments = [
      TripSummarySegment(DummyData.dummyTrip, isPreviewSegment: false),
      TripSummarySegment(DummyData.dummyTrip, isPreviewSegment: true),
      TripDetailsSegment(DummyData.dummyTrip),
      AddTripButton(onTap: () {}),
    ];

    return Theme(
      data: Theme.of(context).copyWith(
        extensions: <ThemeExtension<dynamic>>[
          AppColors.of(context).copyWith(
            primary: LocalTheme.primary,
            secondary: LocalTheme.secondary,
          ),
        ],
      ),
      child: CustomScaffold(
        addScreenInset: false,
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.offset),
              child: Text('Search', style: TextStyles.h1),
            ),
            const SizedBox(height: Insets.lg),
            Ticket(
              onTap: () {},
              topCard: firstSegments[0],
              frontCard: firstSegments[1],
              middleCard: firstSegments[2],
              bottomCard: firstSegments[3],
              tileHeights: firstSegments
                  .map((widget) => widget.preferredSize.height)
                  .toList(),
            ),
            const SizedBox(height: Insets.med),
            TripSummarySegment(DummyData.dummyTrip, isPreviewSegment: false),
            const SizedBox(height: Insets.med),
            TripDetailsSegment(DummyData.dummyTrip),
            const SizedBox(height: Insets.med),
            AddTripButton(onTap: () {}),
          ],
        ),
      ),
    );
  }
}
