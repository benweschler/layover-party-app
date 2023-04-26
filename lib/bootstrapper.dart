import 'package:layover_party/commands/get_trips_command.dart';
import 'package:layover_party/models/app_model.dart';
import 'package:layover_party/models/trip_model.dart';

class Bootstrapper {
  final AppModel appModel;
  final TripModel tripModel;

  const Bootstrapper({required this.appModel, required this.tripModel});

  Future<void> run() async {
    tripModel.trips = await GetTripsCommand.run(
      appModel.user.authToken,
      'SFO',
      'LAX',
      DateTime.now().add(const Duration(days: 1)),
      DateTime.now().add(const Duration(days: 14)),
    );

    appModel.isInitialized = true;
  }
}
