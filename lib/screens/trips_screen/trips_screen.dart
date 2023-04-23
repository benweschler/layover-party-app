import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:layover_party/commands/get_trips_command.dart';
import 'package:layover_party/data/trip/trip.dart';
import 'package:layover_party/models/app_model.dart';
import 'package:layover_party/models/trip_model.dart';
import 'package:layover_party/screens/trips_screen/local_theme.dart';
import 'package:layover_party/utils/iterable_utils.dart';
import 'package:layover_party/utils/navigator_utils.dart';
import 'package:layover_party/widgets/buttons/async_action_button.dart';
import 'package:layover_party/widgets/buttons/responsive_buttons.dart';
import 'package:layover_party/widgets/custom_input_decoration.dart';
import 'package:layover_party/widgets/custom_scaffold.dart';
import 'package:layover_party/widgets/folding_ticket/ticket_segment.dart';
import 'package:layover_party/screens/trips_screen/trip_details_segment.dart';
import 'package:layover_party/screens/trips_screen/trip_preview_segment.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/styles/theme.dart';
import 'package:layover_party/widgets/folding_ticket/ticket.dart';
import 'package:layover_party/widgets/modal_sheets/modal_sheet.dart';
import 'package:provider/provider.dart';

import 'add_trip_button.dart';

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
                const SizedBox(height: Insets.xl * 2.5),
                ...tripList
                    .map<Widget>((trip) => TripTicket(trip))
                    .separate(const SizedBox(height: Insets.lg))
                    .toList()
                  ..add(const SizedBox(height: Insets.xl * 2)),
              ],
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
            Positioned(
              top: Insets.med,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const AirportSearchBar(),
                        DateSelector(
                          startDate: context.select<TripModel, DateTime>(
                            (model) => model.departure,
                          ),
                          endDate: context.select<TripModel, DateTime>(
                            (model) => model.arrival,
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ResponsiveButton(
                        onTap: () => context.showModal(
                          ModalSheet(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Insets.offset,
                                vertical: Insets.lg,
                              ),
                              child: AsyncActionButton(
                                label: 'Search',
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
                            ),
                          ),
                        ),
                        builder: (overlay) => Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: Insets.sm,
                            horizontal: Insets.offset,
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: Insets.xs, horizontal: Insets.med),
                          decoration: ShapeDecoration(
                            shape: const StadiumBorder(),
                            color: Color.alphaBlend(
                              overlay,
                              AppColors.of(context).secondary,
                            ),
                            shadows: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            'Submit',
                            style: TextStyles.body2.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
      AddTripButton(onTap: () {}),
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

class AirportSearchBar extends StatelessWidget {
  const AirportSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Insets.sm,
        horizontal: Insets.lg,
      ),
      decoration: floatingEntryDecoration,
      child: Row(
        children: [
          ResponsiveStrokeButton(
            onTap: () => context.showModal(
              const SelectAirportModal(UpdatedAirport.origin),
            ),
            child: Text(
              context.select<TripModel, String>(
                (model) => model.originCode,
              ),
              style: TextStyles.body1.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: Insets.sm),
          const Icon(Icons.arrow_forward),
          const SizedBox(width: Insets.sm),
          ResponsiveStrokeButton(
            onTap: () => context.showModal(
              const SelectAirportModal(UpdatedAirport.destination),
            ),
            child: Text(
              context.select<TripModel, String>(
                (model) => model.destinationCode,
              ),
              style: TextStyles.body1.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
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
    final dateStyle = TextStyles.body1.copyWith(fontWeight: FontWeight.w600);
    return Container(
      padding: const EdgeInsets.all(Insets.sm),
      decoration: floatingEntryDecoration,
      child: Row(
        children: [
          const SizedBox(width: Insets.sm),
          Text(
            DateFormat.Md().format(startDate),
            style: dateStyle,
          ),
          const SizedBox(width: Insets.sm),
          Text(
            '-',
            style: TextStyles.body1.copyWith(
              color: AppColors.of(context).neutralContent,
            ),
          ),
          const SizedBox(width: Insets.sm),
          Text(
            DateFormat.Md().format(endDate),
            style: dateStyle,
          ),
          const SizedBox(width: Insets.sm),
          const Icon(Icons.calendar_today_outlined),
          const SizedBox(width: Insets.sm),
        ],
      ),
    );
  }
}

enum UpdatedAirport { origin, destination }

class SelectAirportModal extends StatefulWidget {
  final UpdatedAirport updatedAirport;

  const SelectAirportModal(this.updatedAirport, {Key? key}) : super(key: key);

  @override
  State<SelectAirportModal> createState() => _SelectAirportModalState();
}

class _SelectAirportModalState extends State<SelectAirportModal> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ModalSheet(
      child: Padding(
        padding: const EdgeInsets.all(Insets.offset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              decoration: CustomInputDecoration(AppColors.of(context),
                  hintText: 'Enter an airport code'),
            ),
            const SizedBox(height: Insets.lg),
            AsyncActionButton(
              label: 'Update',
              action: () async {
                final tripModel = context.read<TripModel>();

                switch (widget.updatedAirport) {
                  case UpdatedAirport.origin:
                    tripModel.originCode = _controller.value.text;
                    break;
                  case UpdatedAirport.destination:
                    tripModel.destinationCode = _controller.value.text;
                    break;
                }

                context.pop();
              },
              catchError: (_) {},
            ),
          ],
        ),
      ),
    );
  }
}

final floatingEntryDecoration = BoxDecoration(
  borderRadius: Corners.smBorderRadius,
  color: Colors.white,
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 10,
      spreadRadius: 1,
      offset: const Offset(0, 2),
    ),
  ],
);
