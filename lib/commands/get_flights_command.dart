import 'dart:io';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:layover_party/constants.dart';
import 'package:layover_party/data/trip/trip.dart';

abstract class GetFlightsCommand {
  static const int _page = 1;

  static Future<List<Trip>> run(String authToken) async {
    try {
      final Uri url = Uri.https(
        Endpoints.authority,
        Endpoints.flights,
        generateRequestBody(
          originCode: 'SFO',
          destinationCode: 'LAX',
          startDate: DateTime.now(),
          endDate: DateTime(2023, 4, 27),
        ),
      );

      final Response response = await get(
        url,
        headers: {HttpHeaders.authorizationHeader: authToken},
      );
      print(response.body);
    } catch(e) {
      print(e);
      throw Exception(e);
    }


    return [];
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
