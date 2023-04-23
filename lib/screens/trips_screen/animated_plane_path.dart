import 'package:flutter/material.dart';

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
    if (isDark) {
      planeRoutePath = 'assets/tickets/plane_path_grey.png';
      planePath = 'assets/tickets/airplane_grey.png';
    } else {
      planeRoutePath = 'assets/tickets/plane_path_white.png';
      planePath = 'assets/tickets/airplane_white.png';
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
            _AnimatedSlideToRight(
              isOpen: isOpen,
              child: Image.asset(planePath, height: 20, fit: BoxFit.contain),
            )
        ],
      ),
    );
  }
}

class _AnimatedSlideToRight extends StatefulWidget {
  final Widget? child;
  final bool? isOpen;

  const _AnimatedSlideToRight({Key? key, this.child, required this.isOpen})
      : super(key: key);

  @override
  State<_AnimatedSlideToRight> createState() => _AnimatedSlideToRightState();
}

class _AnimatedSlideToRightState extends State<_AnimatedSlideToRight>
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
