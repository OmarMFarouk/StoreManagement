import 'dart:convert';
import 'dart:developer';
import 'package:desktop/blocs/employee_bloc/employee_cubit.dart';
import 'package:desktop/models/products_model.dart';
import 'package:desktop/src/app_endpoints.dart';
import 'package:desktop/src/app_shared.dart';
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

  Future deleteProduct({required String productCode}) async {
    var request = await http.post(Uri.parse(AppEndPoints.deleteProduct),
        body: {'product_code': productCode});
    if (request.statusCode < 300) {
      print(request.body);
      var response = jsonDecode(request.body);
      return response;
    } else {
      log('error');
    }
  }

  Future createReceipt({required data, required total}) async {
    var request = await http.post(Uri.parse(AppEndPoints.createReceipt), body: {
      'total_price': total,
      'receipt_item_list': jsonEncode(data),
      'created_by': currentEmployee.username
    });
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

  Future createReturn({required data, required total}) async {
    var request = await http.post(Uri.parse(AppEndPoints.createReturn), body: {
      'total_price': total,
      'returned_items': jsonEncode(data),
      'created_by': currentEmployee.username
    });
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

  Future fetchReturns() async {
    var request = await http.get(Uri.parse(AppEndPoints.showReturns));
    if (request.statusCode < 300) {
      var response = jsonDecode(request.body);
      return response;
    } else {
      log('error');
    }
  }
}
