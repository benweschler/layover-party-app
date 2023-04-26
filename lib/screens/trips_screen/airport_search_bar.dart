import 'package:flutter/material.dart';
import 'package:layover_party/models/trip_model.dart';
import 'package:layover_party/screens/trips_screen/select_airport_modal.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/utils/navigator_utils.dart';
import 'package:layover_party/widgets/buttons/responsive_buttons.dart';
import 'package:provider/provider.dart';

import 'floating_entry_decoration.dart';

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
              style: TextStyles.body2.copyWith(fontWeight: FontWeight.w600),
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
              style: TextStyles.body2.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
