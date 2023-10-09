import 'package:flutter/material.dart';
import 'package:layover_party/data/trip/trip.dart';
import 'package:layover_party/screens/trips_screen/trip_confirmation_dialog.dart';
import 'package:layover_party/screens/trips_screen/trip_ticket/trip_details_segment.dart';
import 'package:layover_party/screens/trips_screen/trip_ticket/trip_preview_segment.dart';
import 'package:layover_party/widgets/folding_ticket/ticket.dart';
import 'package:layover_party/widgets/folding_ticket/ticket_segment.dart';

import 'add_trip_button.dart';

class TripTicket extends StatefulWidget {
  final Trip trip;

  const TripTicket(this.trip, {Key? key}) : super(key: key);

  @override
  State<TripTicket> createState() => _TripTicketState();
}

class _TripTicketState extends State<TripTicket> {
  @override
  Widget build(BuildContext context) {
    List<TicketSegment> firstSegments = [
      TripSummarySegment(widget.trip, isPreviewSegment: false),
      TripSummarySegment(widget.trip, isPreviewSegment: true),
      TripDetailsSegment(widget.trip),
      AddTripButton(
        onTap: () => showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => TripConfirmationDialog(widget.trip),
        ),
      ),
    ];

    return Ticket(
      onTap: () {},
      topCard: firstSegments[0],
      frontCard: firstSegments[1],
      middleCard: firstSegments[2],
      bottomCard: firstSegments[3],
      tileHeights:
          firstSegments.map((widget) => widget.preferredSize.height).toList(),
    );
  }
}
