import 'package:layover_party/commands/get_trips_command.dart';
import 'package:layover_party/data/trip/trip.dart';
import 'package:layover_party/utils/easy_notifier.dart';

class TripModel extends EasyNotifier {
  String _originCode = 'SFO';
  String _destinationCode = 'LAX';
  DateTime _departure = DateTime.now();
  DateTime _arrival = DateTime(2023, 4, 26);

  DateTime get departure => _departure;
  set departure(DateTime value) => notify(() => _departure = value);

  DateTime get arrival => _arrival;
  set arrival(DateTime value) => notify(() => _arrival = value);

  String get originCode => _originCode;

  set originCode(String value) => notify(() => _originCode = value);

  List<Trip> _trips = [];

  Iterable<Trip> get trips => List.from(_trips);

  set trips(Iterable<Trip> trips) => notify(() => _trips = trips.toList());

  void addTrips(Iterable<Trip> trips) =>
      notify(() => _trips = [..._trips, ...trips]);

  Future<void> initialize(String authToken) async =>
      trips = await GetTripsCommand.run(
          authToken, originCode, destinationCode, departure, arrival);

  String get destinationCode => _destinationCode;

  set destinationCode(String value) => notify(() => _destinationCode = value);
}
