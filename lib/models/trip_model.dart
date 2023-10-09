import 'package:layover_party/data/airport/airport.dart';
import 'package:layover_party/data/flight/flight.dart';
import 'package:layover_party/data/layover/layover.dart';
import 'package:layover_party/data/trip/trip.dart';
import 'package:layover_party/utils/easy_notifier.dart';

class TripModel extends EasyNotifier {
  late List<Trip> _trips;

  String _originCode = 'SFO';
  String _destinationCode = 'HAN';
  DateTime _departureDate = DateTime.now().add(const Duration(days: 1));
  DateTime _arrivalDate = DateTime.now().add(const Duration(days: 14));

  String get originCode => _originCode;

  set originCode(String value) => notify(() => _originCode = value);

  String get destinationCode => _destinationCode;

  set destinationCode(String value) => notify(() => _destinationCode = value);

  DateTime get departureDate => _departureDate;

  set departureDate(DateTime value) => notify(() => _departureDate = value);

  DateTime get arrivalDate => _arrivalDate;

  set arrivalDate(DateTime value) => notify(() => _arrivalDate = value);

  Iterable<Trip> get trips => List.from(_trips);

  set trips(Iterable<Trip> value) => notify(() => _trips = value.toList());

  Future<void> updateTrips(String authToken) async {
    trips = _dummyData;
    // Backend is no longer active :(
    /*
    trips = await GetTripsCommand.run(
      authToken,
      originCode,
      destinationCode,
      departureDate,
      arrivalDate,
    );
    */
  }
}

final List<Trip> _dummyData = [
  _highFidelityDummyTrip,
  // TWO
  Trip(
    flights: _dummyFlights..removeAt(2),
    airline: 'United',
    layovers: [
      Layover(
        duration: DateTime(2023, 5, 12, 8, 37)
            .difference(DateTime(2023, 5, 11, 17, 30)),
        airport: const Airport(code: 'CDG', city: 'Paris'),
      ),
      Layover(
        duration: DateTime(2023, 5, 13, 22, 7)
            .difference(DateTime(2023, 5, 13, 11, 42)),
        airport: const Airport(code: 'HND', city: 'Tokyo'),
      ),
    ],
    totalUsers: 22,
  ),
  // THREE
  Trip(
    flights: _dummyFlights,
    airline: 'Lufthansa',
    layovers: [
      Layover(
        duration: DateTime(2023, 5, 12, 8, 37)
            .difference(DateTime(2023, 5, 12, 7, 30)),
        airport: const Airport(code: 'CDG', city: 'Paris'),
      ),
      Layover(
        duration: DateTime(2023, 5, 12, 22, 18)
            .difference(DateTime(2023, 5, 12, 11, 23)),
        airport: const Airport(code: 'CPH', city: 'Copenhagen'),
      ),
      Layover(
        duration: DateTime(2023, 5, 13, 22, 7)
            .difference(DateTime(2023, 5, 13, 15, 42)),
        airport: const Airport(code: 'HND', city: 'Tokyo'),
      ),
    ],
    totalUsers: 108,
  ),
  // FOUR
  Trip(
    flights: _dummyFlights,
    airline: 'Delta',
    layovers: [
      Layover(
        duration: DateTime(2023, 5, 12, 6, 37)
            .difference(DateTime(2023, 5, 11, 24, 30)),
        airport: const Airport(code: 'CDG', city: 'Paris'),
      ),
      Layover(
        duration: DateTime(2023, 5, 12, 22, 18)
            .difference(DateTime(2023, 5, 11, 11, 23)),
        airport: const Airport(code: 'CPH', city: 'Copenhagen'),
      ),
      Layover(
        duration: DateTime(2023, 5, 13, 22, 7)
            .difference(DateTime(2023, 5, 13, 11, 42)),
        airport: const Airport(code: 'HND', city: 'Tokyo'),
      ),
    ],
    totalUsers: 31,
  ),
  // FIVE
  Trip(
    flights: _dummyFlights,
    airline: 'Lufthansa',
    layovers: [
      Layover(
        duration: DateTime(2023, 5, 12, 8, 37)
            .difference(DateTime(2023, 5, 11, 17, 30)),
        airport: const Airport(code: 'CDG', city: 'Paris'),
      ),
      Layover(
        duration: DateTime(2023, 5, 12, 22, 18)
            .difference(DateTime(2023, 5, 11, 11, 23)),
        airport: const Airport(code: 'CPH', city: 'Copenhagen'),
      ),
      Layover(
        duration: DateTime(2023, 5, 13, 22, 7)
            .difference(DateTime(2023, 5, 13, 11, 42)),
        airport: const Airport(code: 'HND', city: 'Tokyo'),
      ),
    ],
    totalUsers: 22,
  ),
];

final _highFidelityDummyTrip = Trip(
  flights: _dummyFlights,
  airline: 'United',
  layovers: [
    Layover(
      duration: DateTime(2023, 5, 12, 6, 37)
          .difference(DateTime(2023, 5, 10, 17, 30)),
      airport: const Airport(code: 'CDG', city: 'Paris'),
    ),
    Layover(
      duration: DateTime(2023, 5, 12, 22, 18)
          .difference(DateTime(2023, 5, 12, 8, 23)),
      airport: const Airport(code: 'CPH', city: 'Copenhagen'),
    ),
    Layover(
      duration: DateTime(2023, 5, 13, 22, 7)
          .difference(DateTime(2023, 5, 13, 11, 42)),
      airport: const Airport(code: 'HND', city: 'Tokyo'),
    ),
  ],
  totalUsers: 42,
);

final _dummyFlights = [
  Flight(
    origin: const Airport(code: 'SFO', city: 'San Fransisco'),
    destination: const Airport(code: 'CDG', city: 'Paris'),
    departure: DateTime(2023, 5, 10, 7, 10),
    arrival: DateTime(2023, 5, 10, 17, 30),
  ),
  Flight(
    origin: const Airport(code: 'CDG', city: 'Paris'),
    destination: const Airport(code: 'CPH', city: 'Copenhagen'),
    departure: DateTime(2023, 5, 12, 6, 37),
    arrival: DateTime(2023, 5, 12, 8, 23),
  ),
  Flight(
    origin: const Airport(code: 'CPH', city: 'Copenhagen'),
    destination: const Airport(code: 'HND', city: 'Tokyo'),
    departure: DateTime(2023, 5, 12, 22, 18),
    arrival: DateTime(2023, 5, 13, 11, 42),
  ),
  Flight(
    origin: const Airport(code: 'HND', city: 'Tokyo'),
    destination: const Airport(code: 'HAN', city: 'Hanoi'),
    departure: DateTime(2023, 5, 13, 22, 7),
    arrival: DateTime(2023, 5, 13, 23, 54),
  ),
];
