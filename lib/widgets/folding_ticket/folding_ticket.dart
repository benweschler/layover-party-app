import 'dart:math';

import 'package:flutter/material.dart';
import 'package:layover_party/widgets/folding_ticket/ticket_segment.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/widgets/folding_ticket/widget_segment_wrapper.dart';

class FoldingTicket extends StatefulWidget {
  static const double padding = 16.0;
  final bool? isOpen;
  final List<FoldingTicketTile> entries;
  final Function? onClick;
  final Duration? duration;

  const FoldingTicket({
    super.key,
    this.duration,
    required this.entries,
    this.isOpen = false,
    this.onClick,
  });

  @override
  State<FoldingTicket> createState() => _FoldingTicketState();
}

class _FoldingTicketState extends State<FoldingTicket>
    with SingleTickerProviderStateMixin {
  late List<FoldingTicketTile> _entries;
  double _ratio = 0.0;
  late AnimationController _controller;

  double? get openHeight =>
      _entries.fold<double>(0.0, (current, entry) => current + entry.height);

  double get closedHeight => _entries[0].height;

  bool? get isOpen => widget.isOpen;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addListener(_tick);
    _updateFromWidget();
  }

  @override
  void didUpdateWidget(FoldingTicket oldWidget) {
    // Opens or closes the ticked if the status changed
    _updateFromWidget();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Insets.offset),
      height: closedHeight +
          (openHeight! - closedHeight) * Curves.easeOut.transform(_ratio),
      child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.12),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: _buildEntry(0)),
    );
  }

  Widget _buildEntry(int index) {
    FoldingTicketTile entry = _entries[index];
    int count = _entries.length - 1;
    double ratio = max(0.0, min(1.0, _ratio * count + 1.0 - index * 1.0));

    Matrix4 mtx = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..setEntry(1, 2, 0.2)
      ..rotateX(pi * (ratio - 1.0));

    Widget card = SizedBox(
        height: entry.height, child: ratio < 0.5 ? entry.back : entry.front);

    return Transform(
        alignment: Alignment.topCenter,
        transform: mtx,
        child: GestureDetector(
          onTap: widget.onClick as void Function()?,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            // Note: Container supports a transform property, but not alignment for it.
            child: (index == count || ratio <= 0.5)
                ? card
                : // Don't build a stack if it isn't needed.
                Column(children: [
                    card,
                    _buildEntry(index + 1),
                  ]),
          ),
        ));
  }

  void _updateFromWidget() {
    _entries = widget.entries;
    _controller.duration = widget.duration ??
        Duration(
          milliseconds: 400 * (_entries.length - 1),
        );
    isOpen! ? _controller.forward() : _controller.reverse();
  }

  void _tick() {
    setState(() {
      _ratio = Curves.easeInQuad.transform(_controller.value);
    });
  }
}

class FoldingTicketTile {
  final TicketSegment? front;
  TicketSegment? back;
  final double height;

  FoldingTicketTile({
    required this.front,
    required this.height,
    TicketSegment? back,
  }) {
    this.back = WidgetSegmentWrapper(
      builder: (child) => Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, .001)
          ..rotateX(pi),
        child: child,
      ),
      child: back,
    );
  }
}
