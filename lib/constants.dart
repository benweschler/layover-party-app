import 'data/airport/airport.dart';
import 'data/flight/flight.dart';
import 'data/layover/layover.dart';
import 'data/trip/trip.dart';

abstract class Constants {
  static const String version = '0.5.0';
}

abstract class Endpoints {
  static String get authority => 'layover.party';

  static String get _root => '/api';

  static String get logIn => '$_root/login';

  static String get signUp => '$_root/register';

  static String get flights => '$_root/flights';
}

abstract class DummyData {
  static final flights = [flight1, flight2, flight3, flight4];

  static final layovers = [
    for (int i = 0; i < flights.length - 1; i++)
      Layover(
        duration: flights[i + 1].departure.difference(flights[i].arrival),
        airport: flights[i].destination,
      ),
  ];

  static Trip get dummyTrip1 => Trip(
    flights: flights,
    airline: 'Delta',
    layovers: layovers,
    totalUsers: 75,
  );

  static Trip get dummyTrip2 => Trip(
    flights: flights..shuffle(),
    airline: 'Delta',
    layovers: layovers,
    totalUsers: 75,
  );

  static Trip get dummyTrip3 => Trip(
    flights: flights..shuffle(),
    airline: 'Delta',
    layovers: layovers,
    totalUsers: 75,
  );

  static Flight get flight1 => Flight(
        origin: const Airport(code: 'SFO', city: 'San Fransisco'),
        destination: const Airport(code: 'CAN', city: 'Cancun'),
        departure: DateTime(2023, 5, 24, 18),
        arrival: DateTime(2023, 5, 25, 5),
        flightNumber: 'NK234',
      );

  static Flight get flight2 => Flight(
        origin: const Airport(code: 'CAN', city: 'Cancun'),
        destination: const Airport(code: 'BNK', city: 'Bangkok'),
        departure: DateTime(2023, 5, 25, 15),
        arrival: DateTime(2023, 5, 26, 0),
        flightNumber: 'NK234',
      );

  static Flight get flight3 => Flight(
        origin: const Airport(code: 'BNK', city: 'Bangkok'),
        destination: const Airport(code: 'SFO', city: 'San Fransisco'),
        departure: DateTime(2023, 5, 26, 23),
        arrival: DateTime(2023, 5, 27, 8),
        flightNumber: 'NK234',
      );

  static Flight get flight4 => Flight(
        origin: const Airport(code: 'SFO', city: 'San Fransisco'),
        destination: const Airport(code: 'LHX', city: 'LA Hacks'),
        departure: DateTime(2023, 5, 28, 10),
        arrival: DateTime(2023, 5, 29, 8),
        flightNumber: 'NK234',
      );
}
