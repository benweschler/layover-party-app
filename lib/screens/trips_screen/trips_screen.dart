import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:layover_party/commands/get_trips_command.dart';
import 'package:layover_party/data/trip/trip.dart';
import 'package:layover_party/models/app_model.dart';
import 'package:layover_party/models/trip_model.dart';
import 'package:layover_party/screens/trips_screen/trip_ticket/local_theme.dart';
import 'package:layover_party/screens/trips_screen/trip_ticket/trip_ticket.dart';
import 'package:layover_party/utils/iterable_utils.dart';
import 'package:layover_party/widgets/buttons/async_action_button.dart';
import 'package:layover_party/widgets/buttons/responsive_buttons.dart';
import 'package:layover_party/widgets/custom_scaffold.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/styles/theme.dart';
import 'package:provider/provider.dart';

import 'airport_search_bar.dart';
import 'floating_entry_decoration.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Iterable<Trip> tripList =
        context.select<TripModel, List<Trip>>((model) => model.trips.toList());

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
        topSafeArea: false,
        child: Stack(
          children: [
            ListView(
              children: [
                const SizedBox(height: Insets.med),
                ...tripList
                    .map<Widget>((trip) => TripTicket(trip))
                    .separate(const SizedBox(height: Insets.lg))
                    .toList()
                  ..add(const SizedBox(height: Insets.xl * 2)),
              ],
            ),
            Positioned(
              top: Insets.med,
              left: Insets.xl,
              right: Insets.xl,
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AirportSearchBar(),
                        DateSelector(
                          startDate: context.watch<TripModel>().departure,
                          endDate: context.select<TripModel, DateTime>(
                                (model) => model.arrival,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Insets.sm),
                    AsyncActionButton(
                      label: 'Refresh Search',
                      action: () async {
                        final tripModel = context.read<TripModel>();

                        final pop = context.pop;

                        tripModel.trips = await GetTripsCommand.run(
                          context.read<AppModel>().user.authToken,
                          tripModel.originCode,
                          tripModel.destinationCode,
                          tripModel.departure,
                          tripModel.arrival,
                        );

                        pop();
                      },
                      catchError: (e) => print(e),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 60, sigmaY: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).viewPadding.top,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DateSelector extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  const DateSelector({Key? key, required this.startDate, required this.endDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateStyle = TextStyles.body2.copyWith(fontWeight: FontWeight.w600);
    return Container(
      padding: const EdgeInsets.all(Insets.sm),
      decoration: floatingEntryDecoration,
      child: Row(
        children: [
          const SizedBox(width: Insets.sm),
          ResponsiveStrokeButton(
            onTap: () => showDatePicker(
              context: context,
              initialDate: startDate,
              firstDate: DateTime(2023, 1, 1),
              lastDate: DateTime(2023, 8, 1),
            ).then((date) {
              if (date != null) {
                context.read<TripModel>().departure = date;
              }
            }),
            child: Text(
              DateFormat.Md().format(startDate),
              style: dateStyle,
            ),
          ),
          const SizedBox(width: Insets.sm),
          Text(
            '-',
            style: TextStyles.body2.copyWith(
              color: AppColors.of(context).neutralContent,
            ),
          ),
          const SizedBox(width: Insets.sm),
          ResponsiveStrokeButton(
            onTap: () => showDatePicker(
              context: context,
              initialDate: endDate,
              firstDate: DateTime(2023, 1, 1),
              lastDate: DateTime(2023, 8, 1),
            ).then((date) => context.read<TripModel>().arrival = date!),
            child: Text(
              DateFormat.Md().format(endDate),
              style: dateStyle,
            ),
          ),
          const SizedBox(width: Insets.sm),
          const Icon(Icons.calendar_today_outlined),
          const SizedBox(width: Insets.sm),
        ],
      ),
    );
  }
}
