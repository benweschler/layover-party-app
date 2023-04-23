import 'package:http/http.dart';
import 'package:layover_party/constants.dart';
import 'package:layover_party/utils/http_utils.dart';

abstract class SignUpCommand {
  static Future<void> run({
    required String name,
    required String email,
    required String password,
  }) async {
    final Uri url = Uri.https(Endpoints.authority, Endpoints.signUp);

    final Response response = await networkPost(
      url,
      generateRequestBody(name: name, email: email, password: password),
    );

    print(response);

    if (response.statusCode >= 400) {
      print('Server error: ${response.body} ${response.statusCode}');
      throw Exception('Server error');
    }
  }

  static Map<String, dynamic> generateRequestBody({
    required String name,
    required String email,
    required String password,
  }) {
    return {'email': email, 'password': password, 'first_name': name};
  }
}
