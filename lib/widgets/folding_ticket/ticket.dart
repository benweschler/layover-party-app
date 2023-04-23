import 'package:flutter/material.dart';
import 'package:layover_party/styles/theme.dart';
import 'package:layover_party/widgets/folding_ticket/ticket_segment.dart';
import 'package:layover_party/widgets/folding_ticket/widget_segment_wrapper.dart';

import 'folding_ticket.dart';

class Ticket extends StatefulWidget {
  final GestureTapCallback onTap;
  final TicketSegment topCard;
  final TicketSegment frontCard;
  final TicketSegment middleCard;
  final TicketSegment bottomCard;

  /// A list of three doubles corresponding to the heights of each of the three
  /// folding ticket segments.
  final List<double> tileHeights;

  const Ticket({
    Key? key,
    required this.onTap,
    required this.topCard,
    required this.frontCard,
    required this.middleCard,
    required this.bottomCard,
    required this.tileHeights,
  })  : assert(tileHeights.length == 4),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  late final TicketSegment _frontCard = widget.frontCard;
  TicketSegment? _topCard;
  late final TicketSegment _middleCard = widget.middleCard;
  late final TicketSegment _bottomCard = widget.bottomCard;
  bool _isOpen = false;

  TicketSegment get backCard => WidgetSegmentWrapper(
        builder: (_) => Container(
          decoration: BoxDecoration(
            //TODO: change to card color
            color: Color.alphaBlend(
              AppColors.of(context).largeSurface,
              Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ),
        childPreferredSize: _bottomCard.preferredSize,
      );

  @override
  Widget build(BuildContext context) {
    return FoldingTicket(
      entries: [
        FoldingTicketTile(height: widget.tileHeights[0], front: _topCard),
        FoldingTicketTile(
          height: widget.tileHeights[2],
          front: _middleCard,
          back: _frontCard,
        ),
        FoldingTicketTile(
          height: widget.tileHeights[3],
          front: _bottomCard,
          back: backCard,
        )
      ],
      isOpen: _isOpen,
      onClick: _handleOnTap,
    );
  }

  void _handleOnTap() {
    widget.onTap();
    setState(() {
      _isOpen = !_isOpen;
      _topCard = widget.topCard;
    });
  }
}
