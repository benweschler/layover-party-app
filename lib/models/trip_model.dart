import 'package:layover_party/commands/get_trips_command.dart';
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
    trips = await GetTripsCommand.run(
      authToken,
      originCode,
      destinationCode,
      departureDate,
      arrivalDate,
    );
  }
}
