import 'dart:convert';
import 'dart:developer';
import 'package:desktop/src/app_endpoints.dart';
import 'package:http/http.dart' as http;

import '../../src/app_shared.dart';

class EmployeesApi {
  Future fetchEmployees() async {
    var request = await http.get(Uri.parse(AppEndPoints.showEmployees));
    if (request.statusCode < 300) {
      var response = jsonDecode(request.body);
      return response;
    } else {
      log('error');
    }
  }

  Future fetchCurrentEmployeeData() async {
    var request = await http.post(Uri.parse(AppEndPoints.employeeData),
        body: {'username': AppShared.localStorage.getString('username')});
    if (request.statusCode < 300) {
      var response = jsonDecode(request.body);
      return response;
    } else {
      log('error');
    }
  }

  Future createEmployee({required model}) async {
    var request =
        await http.post(Uri.parse(AppEndPoints.createEmployee), body: model);
    print(request.body);
    if (request.statusCode < 300) {
      print(request.body);
      var response = jsonDecode(request.body);
      print(response);
      return response;
    } else {
      log('error');
    }
  }
}
