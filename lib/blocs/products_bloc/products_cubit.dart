import 'dart:convert';

import 'package:desktop/blocs/products_bloc/products_states.dart';
import 'package:desktop/models/products_model.dart';
import 'package:desktop/models/receipt_model.dart';
import 'package:desktop/services/apis/products_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsCubit extends Cubit<ProductsStates> {
  ProductsCubit() : super(ProductsInitial());
  static ProductsCubit get(context) => BlocProvider.of(context);
  var nameController = TextEditingController();
  var quantityController = TextEditingController();
  var codeController = TextEditingController();
  var priceController = TextEditingController();
  ProductsModel? productsModel;
  ReceiptModel? receiptModel;

  fetchProducts() async {
    ProductsApi().fetchProducts().then((r) {
      if (r['success'] == true) {
        productsModel = ProductsModel.fromJson(r);
        emit(ProductsSuccess());
      } else if (r['success'] == false) {
        emit(ProductsFailure(msg: r['message']));
      } else {
        emit(ProductsFailure(msg: 'Error'));
      }
    });
  }

  addProduct() async {
    var productData = Product(
        id: '',
        dateadded: '',
        productimage: '',
        productcode: codeController.text.toUpperCase(),
        productname: nameController.text,
        productprice: priceController.text,
        productquota: quantityController.text);
    ProductsApi().addProduct(data: productData).then((r) {
      if (r['success'] == true) {
        emit(ProductAdded());
        fetchProducts();
        clear();
      } else if (r['success'] == false) {
        emit(ProductsFailure(msg: r['message']));
      } else {
        emit(ProductsFailure(msg: 'Error'));
      }
    });
  }

  updateProduct({required String name, price, code, quota, id}) async {
    var productData = Product(
        dateadded: '',
        productimage: '',
        id: id,
        productcode: code.toUpperCase(),
        productname: name,
        productprice: price,
        productquota: quota);
    ProductsApi().updateProduct(data: productData).then((r) {
      if (r['success'] == true) {
        fetchProducts();
        emit(ProductUpdated());
      } else if (r['success'] == false) {
        emit(ProductsFailure(msg: r['message']));
      } else {
        emit(ProductsFailure(msg: 'Error'));
      }
    });
  }

  createReceipt(List<ReceiptItem> items, total) async {
    ProductsApi()
        .createReceipt(
            data: items.map((e) => e.toJson()).toList(),
            total: total.toString())
        .then((r) {
      if (r['success'] == true) {
        emit(ReceiptCreated(msg: r['message']));
        fetchProducts();
        clear();
      } else if (r['success'] == false) {
        emit(ProductsFailure(msg: r['message']));
      } else {
        emit(ProductsFailure(msg: 'Error'));
      }
    });
  }

  fetchReceipts() async {
    await ProductsApi().fetchReceipts().then((r) {
      if (r['success'] == true) {
        receiptModel = ReceiptModel.fromJson(r);
        emit(ProductsSuccess());
      } else if (r['success'] == false) {
        emit(ProductsFailure(msg: r['message']));
      } else {
        emit(ProductsFailure(msg: 'Error'));
      }
    });
  }

  clear() {
    nameController.clear();
    quantityController.clear();
    codeController.clear();
    priceController.clear();
  }
}
