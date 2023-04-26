import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:layover_party/models/trip_model.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:provider/provider.dart';

import 'floating_entry_decoration.dart';

class AirportSearchBar extends StatelessWidget {
  const AirportSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyles.body2.copyWith(fontWeight: FontWeight.w600);
    final tripModel = context.read<TripModel>();

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Insets.sm,
        horizontal: Insets.lg,
      ),
      decoration: floatingEntryDecoration,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(tripModel.originCode, style: textStyle),
                  const SizedBox(width: Insets.sm),
                  const Icon(Icons.arrow_forward),
                  const SizedBox(width: Insets.sm),
                  Text(tripModel.destinationCode, style: textStyle),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_today_outlined),
                  const SizedBox(width: Insets.sm),
                  Text(
                    DateFormat.Md().format(tripModel.departureDate),
                    style: textStyle,
                  ),
                  const SizedBox(width: Insets.xs),
                  Text('-', style: textStyle),
                  const SizedBox(width: Insets.xs),
                  Text(DateFormat.Md().format(tripModel.arrivalDate),
                      style: textStyle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
