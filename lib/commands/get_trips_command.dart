import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:layover_party/constants.dart';
import 'package:layover_party/data/airport/airport.dart';
import 'package:layover_party/data/flight/flight.dart';
import 'package:layover_party/data/layover/layover.dart';
import 'package:layover_party/data/trip/trip.dart';

abstract class GetTripsCommand {
  static const int _page = 2;

  static Future<List<Trip>> run(
    String authToken,
    String originCode,
    String destinationCode,
    DateTime departure,
    DateTime arrival,
  ) async {
    final Uri url = Uri.https(
      Endpoints.authority,
      Endpoints.flights,
      generateRequestBody(
        originCode: originCode,
        destinationCode: destinationCode,
        startDate: departure,
        endDate: arrival,
      ),
    );

    final Response response = await get(
      url,
      headers: {HttpHeaders.authorizationHeader: authToken},
    );

    final networkResultJson = jsonDecode(response.body) as List<dynamic>;
    final List<Trip> tripList = [];

    for (Map<String, dynamic> resultJson in networkResultJson) {
      final tripData = (resultJson['data']['legs'] as List).first;
      final flightDataList = tripData['segments'] as List;
      final layoverDataList = tripData['layovers'] as List;

      print(flightDataList);

      final List<Flight> flightList = [];
      for (Map<String, dynamic> flightData in flightDataList) {
        flightList.add(
          Flight(
            origin: Airport(
              code: flightData['origin']['displayCode'],
              city: flightData['origin']['city'],
            ),
            destination: Airport(
              code: flightData['destination']['displayCode'],
              city: flightData['destination']['city'],
            ),
            departure: DateTime.parse(flightData['departure']),
            arrival: DateTime.parse(flightData['arrival']),
            flightNumber: flightData['flightNumber'],
          ),
        );
      }

      final List<Layover> layoverList = [];
      for (Map<String, dynamic> layoverData in layoverDataList) {
        layoverList.add(
          Layover(
            duration: Duration(minutes: layoverData['duration']),
            airport: Airport(
              code: layoverData['origin']['displayCode'],
              city: layoverData['origin']['city'],
            ),
          ),
        );
      }

      tripList.add(Trip(
        flights: flightList,
        airline: flightDataList.first['operatingCarrier']['name'],
        layovers: layoverList,
        totalUsers: resultJson['data']['pop_score'],
      ));
    }

    print(tripList.map((trip) => trip.layovers.map((e) => e.airport.city)));

    return tripList;
  }

  static Map<String, dynamic> generateRequestBody({
    required String originCode,
    required String destinationCode,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return {
      'origin': originCode,
      'dest': destinationCode,
      'date': DateFormat('yyyy-MM-dd').format(startDate),
      'return_date': DateFormat('yyyy-MM-dd').format(endDate),
      'page': '$_page',
    };
  }
}
