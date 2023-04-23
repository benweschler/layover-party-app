import 'package:flutter/widgets.dart';

List<TextSpan> formatDuration({
  required Duration duration,
  required TextStyle digitStyle,
  required TextStyle unitStyle,
}) {
  return [
    TextSpan(text: duration.inHours.toString(), style: digitStyle),
    TextSpan(text: 'H ', style: unitStyle),
    TextSpan(
      text: duration.inMinutes.remainder(60).toString(),
      style: digitStyle,
    ),
    TextSpan(text: 'M', style: unitStyle),
  ];
}
