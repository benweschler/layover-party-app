import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:layover_party/models/trip_model.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/styles/theme.dart';
import 'package:layover_party/widgets/buttons/async_action_button.dart';
import 'package:layover_party/widgets/custom_input_decoration.dart';
import 'package:layover_party/widgets/modal_sheets/modal_sheet.dart';
import 'package:provider/provider.dart';

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
              decoration: CustomInputDecoration(
                AppColors.of(context),
                hintText: 'Enter an airport code',
              ),
            ),
            const SizedBox(height: Insets.lg),
            AsyncActionButton(
              label: 'Update',
              action: () async {
                final tripModel = context.read<TripModel>();

                switch (widget.updatedAirport) {
                  case UpdatedAirport.origin:
                    //TODO: tripModel.originCode = _controller.value.text;
                    break;
                  case UpdatedAirport.destination:
                    //TODO: tripModel.destinationCode = _controller.value.text;
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
