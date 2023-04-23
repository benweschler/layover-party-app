import 'dart:convert';

import 'package:http/http.dart';
import 'package:layover_party/constants.dart';
import 'package:layover_party/data/app_user.dart';
import 'package:layover_party/models/app_model.dart';
import 'package:layover_party/utils/http_utils.dart';

abstract class LogInCommand {
  static Future<void> run(
    String email,
    String password,
    AppModel appModel,
  ) async {
    final Uri url = Uri.https(Endpoints.authority, Endpoints.logIn);

    final Response response =
        await networkPost(url, generateRequestBody(email, password));

    //TODO: implement error handling
    if (response.statusCode >= 400) {
      print('Server error: ${response.body} ${response.statusCode}');
      throw Exception('Server error');
    }

    final body = jsonDecode(response.body);

    appModel.user = AppUser(
      email: email,
      id: body['id'],
      authToken: body['token'],
      profilePicURL: body['profile_picture'],
      name: body['first_name'],
    );

    appModel.isLoggedIn = true;
  }

  static Map<String, dynamic> generateRequestBody(
    String email,
    String password,
  ) {
    return {'email': email, 'password': password};
  }
}
