import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:layover_party/models/trip_model.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:provider/provider.dart';

class QuerySearchBar extends StatefulWidget {
  const QuerySearchBar({Key? key}) : super(key: key);

  @override
  State<QuerySearchBar> createState() => _QuerySearchBarState();
}

class _QuerySearchBarState extends State<QuerySearchBar>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late final _controller = AnimationController(
    duration: Timings.med,
    vsync: this,
  );
  late final _shadowAnimation =
      Tween(begin: 0.15, end: 0.3).animate(_controller);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => isExpanded = !isExpanded);
        if(isExpanded) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      child: AnimatedBuilder(
        animation: _shadowAnimation,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.symmetric(
              vertical: Insets.sm,
              horizontal: Insets.lg,
            ),
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
          secondChild: const SearchBarExpandedContent(),
          sizeCurve: Curves.ease,
          duration: Timings.med,
          crossFadeState:
          isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
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
    final tripModel = context.read<TripModel>();

    return IntrinsicHeight(
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
    );
  }
}

class SearchBarExpandedContent extends StatelessWidget {
  const SearchBarExpandedContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        width: double.infinity,
        color: Colors.red,
      ),
    );
  }
}
