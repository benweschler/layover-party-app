import 'package:flutter/material.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/styles/theme.dart';

//TODO: move to utils and change to function returning span list
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
