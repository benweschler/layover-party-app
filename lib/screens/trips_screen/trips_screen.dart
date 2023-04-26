import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:layover_party/data/trip/trip.dart';
import 'package:layover_party/models/trip_model.dart';
import 'package:layover_party/screens/trips_screen/trip_ticket/trip_ticket.dart';
import 'package:layover_party/utils/iterable_utils.dart';
import 'package:layover_party/widgets/custom_scaffold.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:provider/provider.dart';

import 'airport_search_bar.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Iterable<Trip> tripList =
        context.select<TripModel, List<Trip>>((model) => model.trips.toList());

    return CustomScaffold(
      // Ensures that card shadows aren't clipped by list view bug.
      addScreenInset: false,
      topSafeArea: false,
      child: Stack(
        children: [
          ListView(
            children: [
              const SizedBox(height: Insets.xl * 2.5),
              ...tripList
                  .map<Widget>((trip) => TripTicket(trip))
                  .separate(const SizedBox(height: Insets.lg))
                  .toList()
                ..add(const SizedBox(height: Insets.xl * 2)),
            ],
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).viewPadding.top,
              ),
            ),
          ),
          const SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Insets.lg,
                vertical: Insets.sm
              ),
              child: QuerySearchBar(),
            ),
          ),
        ],
      ),
    );
  }
}
