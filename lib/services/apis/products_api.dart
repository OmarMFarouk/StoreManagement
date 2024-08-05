import 'dart:convert';
import 'dart:developer';

import 'package:desktop/models/products_model.dart';
import 'package:desktop/models/receipt_model.dart';
import 'package:desktop/src/app_endpoints.dart';
import 'package:http/http.dart' as http;

class ProductsApi {
  Future fetchProducts() async {
    var request = await http.get(Uri.parse(AppEndPoints.showProducts));
    if (request.statusCode < 300) {
      var response = jsonDecode(request.body);
      return response;
    } else {
      log('error');
    }
  }

  Future updateProduct({required Product data}) async {
    var request = await http.post(Uri.parse(AppEndPoints.updateProduct),
        body: data.toJson());
    print(data.toJson());
    if (request.statusCode < 300) {
      print(request.body);
      var response = jsonDecode(request.body);
      return response;
    } else {
      log('error');
    }
  }

  Future addProduct({required Product data}) async {
    var request = await http.post(Uri.parse(AppEndPoints.addProduct),
        body: data.toJson());
    print(data.toJson());
    if (request.statusCode < 300) {
      print(request.body);
      var response = jsonDecode(request.body);
      return response;
    } else {
      log('error');
    }
  }

  Future createReceipt({required data, required total}) async {
    var request = await http.post(Uri.parse(AppEndPoints.createReceipt),
        body: {'total_price': total, 'receipt_item_list': jsonEncode(data)});
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

  Future fetchReceipts() async {
    var request = await http.get(Uri.parse(AppEndPoints.showReceipts));
    if (request.statusCode < 300) {
      var response = jsonDecode(request.body);
      return response;
    } else {
      log('error');
    }
  }
}
