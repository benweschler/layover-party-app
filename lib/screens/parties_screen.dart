import 'dart:math';

import 'package:flutter/material.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/widgets/ticket.dart';

class PartiesScreen extends StatefulWidget {
  const PartiesScreen({Key? key}) : super(key: key);

  @override
  State<PartiesScreen> createState() => _PartiesScreenState();
}

class _PartiesScreenState extends State<PartiesScreen> {
  bool _isOpen = true;

  @override
  Widget build(BuildContext context) {
    final demo = DemoData();
    return Scaffold(
      body: ListView(
        children: [
          const Text('Search', style: TextStyles.h1),
          const SizedBox(height: Insets.lg),
          Ticket(
            onClick: () {
              setState(() => _isOpen = !_isOpen);
              print('tester $_isOpen');
            },
            frontCard: FlightSummary(
              demo.getBoardingPass(0),
              theme: SummaryTheme.dark,
              isOpen: _isOpen,
            ),
            middleCard: Container(
              color: Colors.blue,
              child: FlightSummary(demo.getBoardingPass(1)),
            ),
            bottomCard: Container(
              color: Colors.green,
            ),
            tileHeights: const [160, 160, 80],
          ),
          Ticket(
            onClick: () => print('open 1'),
            frontCard: Container(color: Colors.blue),
            middleCard: Container(color: Colors.red),
            bottomCard: Container(color: Colors.green),
            tileHeights: const [160, 160, 80],
          ),
        ],
      ),
    );
  }
}

enum SummaryTheme { dark, light }

class FlightSummary extends StatelessWidget {
  final BoardingPassData boardingPass;
  final SummaryTheme theme;
  final bool? isOpen;

  const FlightSummary(
    this.boardingPass, {
    Key? key,
    this.theme = SummaryTheme.light,
    this.isOpen = false,
  }) : super(key: key);

  Color? get mainTextColor {
    Color? textColor;
    if (theme == SummaryTheme.dark) textColor = Colors.white;
    if (theme == SummaryTheme.light) textColor = Color(0xFF083e64);
    return textColor;
  }

  Color? get secondaryTextColor {
    Color? textColor;
    if (theme == SummaryTheme.dark) textColor = Color(0xff61849c);
    if (theme == SummaryTheme.light) textColor = Color(0xFF838383);
    return textColor;
  }

  Color? get separatorColor {
    Color? color;
    if (theme == SummaryTheme.light) color = Color(0xffeaeaea);
    if (theme == SummaryTheme.dark) color = Color(0xff396583);
    return color;
  }

  TextStyle get bodyTextStyle =>
      TextStyle(color: mainTextColor, fontSize: 13, fontFamily: 'Oswald');

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: _getBackgroundDecoration(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildLogoHeader(),
                _buildSeparationLine(),
                _buildTicketHeader(context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Stack(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.centerLeft,
                          child: _buildTicketOrigin()),
                      Align(
                          alignment: Alignment.center,
                          child: _buildTicketDuration()),
                      Align(
                          alignment: Alignment.centerRight,
                          child: _buildTicketDestination())
                    ],
                  ),
                ),
                _buildBottomIcon()
              ],
            ),
          ),
        ),
        Container(
          color: Colors.white.withOpacity(0.2),
        ),
      ],
    );
  }

  _getBackgroundDecoration() {
    if (theme == SummaryTheme.light) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.white,
      );
    }
    if (theme == SummaryTheme.dark) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.blue,
      );
    }
  }

  _buildLogoHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: FlutterLogo(size: 8),
        ),
        Text(
          'Fluttair'.toUpperCase(),
          style: TextStyle(
            color: mainTextColor,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        )
      ],
    );
  }

  Widget _buildSeparationLine() {
    return Container(
      width: double.infinity,
      height: 1,
      color: separatorColor,
    );
  }

  Widget _buildTicketHeader(context) {
    var headerStyle = const TextStyle(
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.bold,
        fontSize: 11,
        color: Color(0xFFe46565));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(boardingPass.passengerName!.toUpperCase(), style: headerStyle),
        Text('BOARDING ${boardingPass.boardingTime!.format(context)}',
            style: headerStyle),
      ],
    );
  }

  Widget _buildTicketOrigin() {
    return Column(
      children: <Widget>[
        Text(
          boardingPass.origin!.code!.toUpperCase(),
          style: bodyTextStyle.copyWith(fontSize: 42),
        ),
        Text(boardingPass.origin!.city!,
            style: bodyTextStyle.copyWith(color: secondaryTextColor)),
      ],
    );
  }

  Widget _buildTicketDuration() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: 120,
            height: 58,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  color: Colors.white,
                  height: 5,
                  width: 50,
                ),
                if (theme == SummaryTheme.light)
                  Transform.rotate(
                    angle: pi / 2,
                    child: const Icon(Icons.airplanemode_active),
                  ),
                if (theme == SummaryTheme.dark)
                  _AnimatedSlideToRight(
                    isOpen: isOpen,
                    child: Transform.rotate(
                      angle: pi / 2,
                      child: const Icon(Icons.airplanemode_active),
                    ),
                  )
              ],
            ),
          ),
          Text(boardingPass.duration.toString(),
              textAlign: TextAlign.center, style: bodyTextStyle),
        ],
      ),
    );
  }

  Widget _buildTicketDestination() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          boardingPass.destination!.code!.toUpperCase(),
          style: bodyTextStyle.copyWith(fontSize: 42),
        ),
        Text(
          boardingPass.destination!.city!,
          style: bodyTextStyle.copyWith(color: secondaryTextColor),
        ),
      ],
    );
  }

  Widget _buildBottomIcon() {
    IconData? icon;
    if (theme == SummaryTheme.light) icon = Icons.keyboard_arrow_down;
    if (theme == SummaryTheme.dark) icon = Icons.keyboard_arrow_up;
    return Icon(
      icon,
      color: mainTextColor,
      size: 18,
    );
  }
}

class _AnimatedSlideToRight extends StatefulWidget {
  final Widget? child;
  final bool? isOpen;

  const _AnimatedSlideToRight({Key? key, this.child, required this.isOpen})
      : super(key: key);

  @override
  _AnimatedSlideToRightState createState() => _AnimatedSlideToRightState();
}

class _AnimatedSlideToRightState extends State<_AnimatedSlideToRight>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1700),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isOpen!) _controller.forward(from: 0);
    return SlideTransition(
      position: Tween(begin: const Offset(-2, 0), end: const Offset(1, 0))
          .animate(
              CurvedAnimation(curve: Curves.easeOutQuad, parent: _controller)),
      child: widget.child,
    );
  }
}

class BoardingPassData {
  String? passengerName;
  _Airport? origin;
  _Airport? destination;
  _Duration? duration;
  TimeOfDay? boardingTime;
  DateTime? departs;
  DateTime? arrives;
  String? gate;
  int? zone;
  String? seat;
  String? flightClass;
  String? flightNumber;

  BoardingPassData({
    this.passengerName,
    this.origin,
    this.destination,
    this.duration,
    this.boardingTime,
    this.departs,
    this.arrives,
    this.gate,
    this.zone,
    this.seat,
    this.flightClass,
    this.flightNumber,
  });
}

class _Airport {
  String? code;
  String? city;

  _Airport({this.city, this.code});
}

class _Duration {
  int? hours;
  int? minutes;

  _Duration({this.hours, this.minutes});

  @override
  String toString() {
    return '\t${hours}H ${minutes}M';
  }
}

class DemoData {
  final List<BoardingPassData> _boardingPasses = [
    BoardingPassData(
        passengerName: 'Ms. Jane Doe',
        origin: _Airport(code: 'YEG', city: 'Edmonton'),
        destination: _Airport(code: 'LAX', city: 'Los Angeles'),
        duration: _Duration(hours: 3, minutes: 30),
        boardingTime: const TimeOfDay(hour: 7, minute: 10),
        departs: DateTime(2019, 10, 17, 23, 45),
        arrives: DateTime(2019, 10, 18, 02, 15),
        gate: '50',
        zone: 3,
        seat: '12A',
        flightClass: 'Economy',
        flightNumber: 'AC237'),
    BoardingPassData(
        passengerName: 'Ms. Jane Doe',
        origin: _Airport(code: 'YYC', city: 'Calgary'),
        destination: _Airport(code: 'YOW', city: 'Ottawa'),
        duration: _Duration(hours: 3, minutes: 50),
        boardingTime: const TimeOfDay(hour: 12, minute: 15),
        departs: DateTime(2019, 10, 17, 23, 45),
        arrives: DateTime(2019, 10, 18, 02, 15),
        gate: '22',
        zone: 1,
        seat: '17C',
        flightClass: 'Economy',
        flightNumber: 'AC237'),
    BoardingPassData(
        passengerName: 'Ms. Jane Doe',
        origin: _Airport(code: 'YEG', city: 'Edmonton'),
        destination: _Airport(code: 'MEX', city: 'Mexico'),
        duration: _Duration(hours: 4, minutes: 15),
        boardingTime: const TimeOfDay(hour: 16, minute: 45),
        departs: DateTime(2019, 10, 17, 23, 45),
        arrives: DateTime(2019, 10, 18, 02, 15),
        gate: '30',
        zone: 2,
        seat: '22B',
        flightClass: 'Economy',
        flightNumber: 'AC237'),
    BoardingPassData(
        passengerName: 'Ms. Jane Doe',
        origin: _Airport(code: 'YYC', city: 'Calgary'),
        destination: _Airport(code: 'YOW', city: 'Ottawa'),
        duration: _Duration(hours: 3, minutes: 50),
        boardingTime: const TimeOfDay(hour: 12, minute: 15),
        departs: DateTime(2019, 10, 17, 23, 45),
        arrives: DateTime(2019, 10, 18, 02, 15),
        gate: '22',
        zone: 1,
        seat: '17C',
        flightClass: 'Economy',
        flightNumber: 'AC237'),
  ];

  get boardingPasses => _boardingPasses;

  getBoardingPass(int index) {
    return _boardingPasses.elementAt(index);
  }
}
