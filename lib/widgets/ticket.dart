import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'folding_ticket.dart';

class Ticket extends StatefulWidget {
  final Function onClick;
  final Widget frontCard;
  final Widget middleCard;
  final Widget bottomCard;

  /// A list of three doubles corresponding to the heights of each of the three
  /// folding ticket segments.
  final List<double> tileHeights;

  const Ticket({
    Key? key,
    required this.onClick,
    required this.frontCard,
    required this.middleCard,
    required this.bottomCard,
    required this.tileHeights,
  })  : assert(tileHeights.length == 3),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  late final Widget _frontCard = widget.frontCard;
  Widget? _topCard;
  late final Widget _middleCard = widget.middleCard;
  late final Widget _bottomCard = widget.bottomCard;
  bool _isOpen = false;

  Widget get backCard => Container(
        decoration: BoxDecoration(
          //TODO: hardcoded
          borderRadius: BorderRadius.circular(4.0),
          color: const Color(0xffdce6ef),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FoldingTicket(
      entries: [
        FoldingTicketTile(height: widget.tileHeights[0], front: _topCard),
        FoldingTicketTile(height: widget.tileHeights[1], front: _middleCard, back: _frontCard),
        FoldingTicketTile(height: widget.tileHeights[2], front: _bottomCard, back: backCard)
      ],
      isOpen: _isOpen,
      onClick: _handleOnTap,
    );
  }

  void _handleOnTap() {
    widget.onClick();
    setState(() {
      _isOpen = !_isOpen;
      //TODO: update with correct preview
      _topCard = widget.frontCard;
    });
  }
}
