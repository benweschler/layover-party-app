import 'package:layover_party/models/app_model.dart';
import 'package:layover_party/models/trip_model.dart';

class Bootstrapper {
  final AppModel appModel;
  final TripModel tripModel;

  const Bootstrapper({required this.appModel, required this.tripModel});

  Future<void> run() async {
    tripModel.updateTrips(appModel.user.authToken);
    appModel.isInitialized = true;
  }
}
