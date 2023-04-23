import 'package:layover_party/data/flight/flight.dart';
import 'package:layover_party/data/layover/layover.dart';

class Trip {
  final List<Flight> flights;
  final String airline;
  final List<Layover> layovers;
  final int totalUsers;

  Trip({
    required this.flights,
    required this.airline,
    required this.layovers,
    required this.totalUsers,
  });
}
