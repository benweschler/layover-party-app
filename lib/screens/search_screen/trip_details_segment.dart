import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:layover_party/data/trip/trip.dart';
import 'package:layover_party/widgets/folding_ticket/ticket_segment.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/styles/theme.dart';
import 'package:layover_party/utils/iterable_utils.dart';
import 'package:layover_party/utils/stat_utils.dart';

class TripDetailsSegment extends StatelessWidget implements TicketSegment {
  final Trip trip;

  const TripDetailsSegment(this.trip, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.all(Insets.lg),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          Row(
            children: trip.layovers
                .map((layover) => Text.rich(TextSpan(
                      children: formatDuration(
                        duration: layover.duration,
                        digitStyle: TextStyles.h2.copyWith(
                          color: AppColors.of(context).secondary,
                          fontWeight: FontWeight.bold,
                        ),
                        unitStyle: TextStyles.body2.copyWith(
                          color: AppColors.of(context).secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )))
                .map((e) => Expanded(child: Center(child: e)))
                .toList(),
          ),
          Row(
            children: trip.layovers
                .map((layover) => _CityText(layover.airport.city))
                .map((e) => Expanded(child: Center(child: e)))
                .toList(),
          ),
          const SizedBox(height: Insets.sm),
          _AirportRow(trip),
          const SizedBox(height: Insets.xs),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(147);
}

class _AirportRow extends StatelessWidget {
  final Trip trip;

  const _AirportRow(this.trip, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final airportCodes = trip.flights.map((flight) => flight.destination.code);
    final codeStyle = TextStyles.body1.copyWith(
      color: AppColors.of(context).primary,
      fontWeight: FontWeight.w600,
    );

    return Column(
      children: [
        Row(
          children: airportCodes
              .map<Widget>((code) => Text(code, style: codeStyle))
              .separate(Expanded(
                child: DottedLine(
                  dashColor: Colors.black.withOpacity(0.7),
                  dashLength: 2,
                  dashGapLength: 5,
                  lineThickness: 2,
                  dashRadius: 2,
                ),
              ))
              .toList()
              .separate(const SizedBox(width: Insets.sm))
              .toList(),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildCodeRow(
            AppColors.of(context),
            airportCodes,
            codeStyle,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCodeRow(
      AppColors appColors, Iterable<String> airportCodes, TextStyle codeStyle) {
    final digitStyle = TextStyles.body2.copyWith(
      color: Colors.black,
    );
    final unitStyle = TextStyles.caption.copyWith(
      color: Colors.black,
    );
    final codeWidgets = [
      ...airportCodes
          .map<Widget>((code) => Text(
                code,
                style: codeStyle.copyWith(color: Colors.transparent),
              ))
          .toList()
    ];

    List<Widget> durationWidgets = trip.flights.map((flight) {
      return Expanded(
        child: Center(
          child: Text.rich(TextSpan(
            children: formatDuration(
              duration: flight.arrival.difference(flight.departure),
              digitStyle: digitStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unitStyle: unitStyle,
            ),
          )),
        ),
      );
    }).toList();

    int i = 0;

    return codeWidgets.expand((element) {
      if (i < codeWidgets.length - 1) {
        return [element, durationWidgets[i++]];
      } else {
        return [element];
      }
    }).toList();
  }
}

class _CityText extends StatelessWidget {
  final String city;

  const _CityText(this.city, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      city,
      textAlign: TextAlign.center,
      style: TextStyles.caption.copyWith(
        color: AppColors.of(context).neutralContent,
      ),
    );
  }
}
