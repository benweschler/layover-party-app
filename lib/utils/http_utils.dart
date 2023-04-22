import 'dart:convert';

import 'package:http/http.dart';

Future<Response> networkPost(Uri url, Map<String, dynamic> body) {
  return post(
    url,
    headers: {'content-type': 'application/json'},
    body: jsonEncode(body),
  );
}
