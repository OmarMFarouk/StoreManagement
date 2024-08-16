import 'dart:convert';
import 'dart:developer';
import 'package:desktop/src/app_endpoints.dart';
import 'package:http/http.dart' as http;

import '../models/clients_model.dart';

class ClientsApi {
  Future fetchClients() async {
    var request = await http.get(Uri.parse(AppEndPoints.showClients));
    if (request.statusCode < 300) {
      var response = jsonDecode(request.body);
      return response;
    } else {
      log('error');
    }
  }

  Future addClient({required Client client}) async {
    var request = await http.post(Uri.parse(AppEndPoints.addClient),
        body: client.toJson());
    if (request.statusCode < 300) {
      var response = jsonDecode(request.body);
      return response;
    } else {
      log('error');
    }
  }

  Future deleteClient({required String clientId}) async {
    var request = await http.post(Uri.parse(AppEndPoints.deleteClient),
        body: {'client_id': clientId});
    if (request.statusCode < 300) {
      var response = jsonDecode(request.body);
      return response;
    } else {
      log('error');
    }
  }
}
