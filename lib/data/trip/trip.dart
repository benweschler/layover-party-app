import 'package:layover_party/data/flight/flight.dart';
import 'package:layover_party/data/layover/layover.dart';

class Trip {
  final List<Flight> flights;
  final String airline;
  late final List<Layover> layovers;

  Trip({
    required this.flights,
    required this.airline,
    required this.layovers,
  });
}
