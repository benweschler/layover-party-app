import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:layover_party/models/app_model.dart';
import 'package:layover_party/models/trip_model.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/styles/theme.dart';
import 'package:layover_party/utils/validators.dart';
import 'package:layover_party/widgets/buttons/async_action_button.dart';
import 'package:layover_party/widgets/buttons/responsive_buttons.dart';
import 'package:layover_party/widgets/custom_input_decoration.dart';
import 'package:provider/provider.dart';

class QuerySearchBar extends StatefulWidget {
  const QuerySearchBar({Key? key}) : super(key: key);

  @override
  State<QuerySearchBar> createState() => _QuerySearchBarState();
}

class _QuerySearchBarState extends State<QuerySearchBar>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late final _controller = AnimationController(
    duration: Timings.med,
    vsync: this,
  );
  late final _shadowAnimation =
      Tween(begin: 0.15, end: 0.3).animate(_controller);

  void _expand() {
    setState(() => _isExpanded = true);
    _controller.forward();
  }

  void _collapse() {
    setState(() => _isExpanded = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_isExpanded) {
          _expand();
        }
      },
      child: AnimatedBuilder(
        animation: _shadowAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: Corners.smBorderRadius,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_shadowAnimation.value),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: child,
          );
        },
        child: AnimatedCrossFade(
          firstChild: const SearchBarPreviewContent(),
          secondChild: SearchBarExpandedContent(
            collapseSearchBar: _collapse,
          ),
          firstCurve: Curves.ease,
          secondCurve: Curves.ease,
          sizeCurve: Curves.ease,
          duration: Timings.med,
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        ),
      ),
    );
  }
}

class SearchBarPreviewContent extends StatelessWidget {
  const SearchBarPreviewContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyles.body2.copyWith(fontWeight: FontWeight.w600);

    return Consumer<TripModel>(
      builder: (_, tripModel, __) => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Insets.sm,
          horizontal: Insets.lg,
        ),
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
      ),
    );
  }
}

class SearchBarExpandedContent extends StatefulWidget {
  final VoidCallback collapseSearchBar;

  const SearchBarExpandedContent({
    Key? key,
    required this.collapseSearchBar,
  }) : super(key: key);

  @override
  State<SearchBarExpandedContent> createState() =>
      _SearchBarExpandedContentState();
}

class _SearchBarExpandedContentState extends State<SearchBarExpandedContent> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey();

  Future<void> searchFlights() async {
    if (!_formKey.currentState!.saveAndValidate()) return;

    final tripModel = context.read<TripModel>();

    tripModel.originCode = _formKey.currentState!.value['origin'];
    tripModel.destinationCode =
    _formKey.currentState!.value['destination'];
    tripModel.departureDate =
        _formKey.currentState!.value['dates'].start;
    tripModel.arrivalDate =
        _formKey.currentState!.value['dates'].end;

    await tripModel.updateTrips(
      context.read<AppModel>().user.authToken,
    );

    widget.collapseSearchBar();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Insets.lg,
        horizontal: Insets.lg,
      ),
      child: FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    name: 'origin',
                    decoration: CustomInputDecoration(
                      AppColors.of(context),
                      hintText: 'From',
                    ),
                    validator: Validators.required(),
                  ),
                ),
                const SizedBox(width: Insets.med),
                const Icon(Icons.swap_horiz_rounded),
                const SizedBox(width: Insets.med),
                Expanded(
                  child: FormBuilderTextField(
                    name: 'destination',
                    decoration: CustomInputDecoration(AppColors.of(context),
                        hintText: 'To'),
                    validator: Validators.required(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Insets.med),
            FormBuilderDateRangePicker(
              name: 'dates',
              firstDate: DateTime.now().add(const Duration(days: 1)),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              decoration: CustomInputDecoration(
                AppColors.of(context),
                hintText: 'Choose dates',
              ),
              validator: Validators.required(),
            ),
            const SizedBox(height: Insets.lg),
            AsyncActionButton<Object>(
              label: 'Search',
              action: searchFlights,
              catchError: (e) => print(e),
            ),
            const SizedBox(height: Insets.med),
            ResponsiveStrokeButton(
              onTap: widget.collapseSearchBar,
              //TODO: make this better
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Cancel',
                    style: TextStyles.body1.copyWith(
                      color: AppColors.of(context).primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
