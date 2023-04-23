import 'package:layover_party/commands/get_trips_command.dart';
import 'package:layover_party/data/trip/trip.dart';
import 'package:layover_party/utils/easy_notifier.dart';

class TripModel extends EasyNotifier {
  List<Trip> _trips = [];

  Iterable<Trip> get trips => List.from(_trips);

  set trips(Iterable<Trip> trips) => notify(() => _trips = trips.toList());

  void addTrips(Iterable<Trip> trips) =>
      notify(() => _trips = [..._trips, ...trips]);

  Future<void> initialize(String authToken) async =>
      trips = await GetTripsCommand.run(authToken);
}
