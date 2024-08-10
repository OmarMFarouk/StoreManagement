import 'dart:convert';
import 'package:desktop/src/app_endpoints.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  Future loginUser(
      {required String username,
      required String password,
      required String role}) async {
    try {
      http.Response request = await http.post(Uri.parse(AppEndPoints.loginUser),
          body: {'username': username, 'password': password, 'role': role});
      if (request.statusCode < 300) {
        var response = jsonDecode(request.body);
        return response;
      }
    } catch (e) {
      return e.toString();
    }
  }
}
