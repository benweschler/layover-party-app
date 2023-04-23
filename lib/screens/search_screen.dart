import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:layover_party/constants.dart';
import 'package:layover_party/data/trip/trip.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/styles/theme.dart';
import 'package:layover_party/utils/iterable_utils.dart';
import 'package:layover_party/widgets/buttons/responsive_buttons.dart';
import 'package:layover_party/widgets/custom_divider.dart';
import 'package:layover_party/widgets/custom_scaffold.dart';

const localGradient = LinearGradient(
  colors: [Color(0xFF86009C), Color(0xFF5100B8)],
);

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        extensions: <ThemeExtension<dynamic>>[
          AppColors.of(context).copyWith(
            primary: const Color(0xFFba26d1),
            secondary: const Color(0xFF5100B8),
          ),
        ],
      ),
      child: CustomScaffold(
        child: ListView(
          children: [
            const Text('Search', style: TextStyles.h1),
            const SizedBox(height: Insets.lg),
            TripPreviewCard(DummyData.dummyTrip, isDark: false),
            const SizedBox(height: Insets.med),
            TripDetailsCard(DummyData.dummyTrip),
            const SizedBox(height: Insets.med),
            AddTripButton(onTap: () {}),
          ],
        ),
      ),
    );
  }
}

class TripPreviewCard extends StatelessWidget {
  final Trip trip;
  final bool isDark;

  const TripPreviewCard(this.trip, {Key? key, required this.isDark})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headingStyle = TextStyles.h1.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );
    final captionStyle = TextStyles.caption.copyWith(
      color: AppColors.of(context).neutralOnContainer,
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Insets.xs,
        horizontal: Insets.lg,
      ),
      decoration: BoxDecoration(
        //color: Colors.white,
        gradient: localGradient,
        borderRadius: Corners.smBorderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            trip.airline.toUpperCase(),
            style: TextStyles.caption.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: Insets.xs),
          CustomDivider(color: AppColors.of(context).dividerOnContainer),
          const SizedBox(height: Insets.sm),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text("40H", style: headingStyle),
                    Text("Total Layover", style: captionStyle),
                  ],
                ),
              ),
              const AnimatedPlanePath(isDark: true, isOpen: true),
              Expanded(
                child: Column(
                  children: [
                    Text("1.4K", style: headingStyle),
                    Text("Total Partiers", style: captionStyle),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Insets.xs),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white.withOpacity(0.6),
          ),
        ],
      ),
    );
  }
}

class AnimatedPlanePath extends StatelessWidget {
  final bool isOpen;
  final bool isDark;

  const AnimatedPlanePath({
    Key? key,
    required this.isOpen,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String planeRoutePath;
    String planePath;
    if (!isDark) {
      planeRoutePath = 'assets/plane_path_blue.png';
      planePath = 'assets/airplane_blue.png';
    } else {
      planeRoutePath = 'assets/plane_path_white.png';
      planePath = 'assets/airplane_white.png';
    }

    return SizedBox(
      width: 120,
      height: 58,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.asset(planeRoutePath, fit: BoxFit.cover),
          if (!isDark)
            Image.asset(planePath, height: 20, fit: BoxFit.contain)
          else
            AnimatedSlideToRight(
              isOpen: isOpen,
              child: Image.asset(planePath, height: 20, fit: BoxFit.contain),
            )
        ],
      ),
    );
  }
}

class AddTripButton extends StatelessWidget implements PreferredSizeWidget {
  final GestureTapCallback onTap;

  const AddTripButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(
        vertical: Insets.sm,
        horizontal: Insets.lg,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: Corners.smBorderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ResponsiveButton.large(
        onTap: onTap,
        builder: (_) => Container(
          padding: const EdgeInsets.symmetric(vertical: Insets.sm),
          decoration: const ShapeDecoration(
            shape: StadiumBorder(),
            color: Colors.black,
          ),
          child: Center(
            child: Text(
              'Go on Trip',
              style: TextStyles.body2.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(65);
}

class AnimatedSlideToRight extends StatefulWidget {
  final Widget? child;
  final bool? isOpen;

  const AnimatedSlideToRight({Key? key, this.child, required this.isOpen})
      : super(key: key);

  @override
  State<AnimatedSlideToRight> createState() => _AnimatedSlideToRightState();
}

class _AnimatedSlideToRightState extends State<AnimatedSlideToRight>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1700),
  );
  late final _positionAnimation = Tween(
    begin: const Offset(-2, 0),
    end: const Offset(1, 0),
  ).animate(CurvedAnimation(curve: Curves.easeOutQuad, parent: _controller));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isOpen!) {
      _controller.forward(from: 0);
    }

    return SlideTransition(position: _positionAnimation, child: widget.child);
  }
}

class TripDetailsCard extends StatelessWidget {
  final Trip trip;

  const TripDetailsCard(this.trip, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Insets.sm,
        horizontal: Insets.lg,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: Corners.smBorderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: trip.layovers
                .map((layover) => DurationText(
                      duration: layover.duration,
                      digitStyle: TextStyles.h2.copyWith(
                        color: AppColors.of(context).secondary,
                        fontWeight: FontWeight.bold,
                      ),
                      unitStyle: TextStyles.body2.copyWith(
                        color: AppColors.of(context).secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ))
                .map((e) => Expanded(child: Center(child: e)))
                .toList(),
          ),
          Row(
            children: trip.layovers
                .map((layover) => CityText(layover.airport.city))
                .map((e) => Expanded(child: Center(child: e)))
                .toList(),
          ),
          const SizedBox(height: Insets.sm),
          AirportRow(trip),
          const SizedBox(height: Insets.xs),
        ],
      ),
    );
  }
}

class AirportRow extends StatelessWidget {
  final Trip trip;

  const AirportRow(this.trip, {Key? key}) : super(key: key);

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
    final durationStyle = TextStyles.caption.copyWith(
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

    List<Widget> durationWidgets = trip.flights
        .map((flight) {
          return Expanded(
              child: Center(
                child: DurationText(
                  duration: flight.arrival.difference(flight.departure),
                  digitStyle: durationStyle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  unitStyle: durationStyle,
                ),
              ),
            );
        })
        .toList();

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

class DurationText extends StatelessWidget {
  final Duration duration;
  final TextStyle digitStyle;
  final TextStyle unitStyle;

  const DurationText({
    Key? key,
    required this.duration,
    required this.digitStyle,
    required this.unitStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(children: [
      TextSpan(text: duration.inHours.toString(), style: digitStyle),
      TextSpan(text: 'H ', style: unitStyle),
      TextSpan(
        text: duration.inMinutes.remainder(60).toString(),
        style: digitStyle,
      ),
      TextSpan(text: 'M', style: unitStyle),
    ]));
  }
}

class CityText extends StatelessWidget {
  final String city;

  const CityText(this.city, {Key? key}) : super(key: key);

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
