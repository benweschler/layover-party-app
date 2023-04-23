import 'package:flutter/material.dart';
import 'package:layover_party/widgets/folding_ticket/ticket_segment.dart';

class WidgetSegmentWrapper extends StatelessWidget implements TicketSegment {
  final Widget Function(Widget? child) builder;
  final TicketSegment? child;
  final Size? childPreferredSize;

  const WidgetSegmentWrapper({
    Key? key,
    required this.builder,
    this.child,
    this.childPreferredSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return builder(child);
  }

  @override
  Size get preferredSize =>
      child?.preferredSize ?? childPreferredSize ?? const Size.fromHeight(0);
}
