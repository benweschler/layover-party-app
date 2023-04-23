import 'package:layover_party/data/airport/airport.dart';

class Flight {
  final Airport origin;
  final Airport destination;
  final DateTime departure;
  final DateTime arrival;
  final String flightNumber;

  const Flight({
    required this.origin,
    required this.destination,
    required this.departure,
    required this.arrival,
    required this.flightNumber,
  });
}