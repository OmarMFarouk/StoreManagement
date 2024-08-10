class Receipt {
  String? id;
  List<ReceiptItem?>? receiptitemlist;
  String? totalprice;
  String? datecreated;
  String? employee;

  Receipt(
      {this.id,
      this.receiptitemlist,
      this.totalprice,
      this.datecreated,
      this.employee});

  Receipt.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['receipt_item_list'] != null) {
      receiptitemlist = <ReceiptItem>[];
      json['receipt_item_list'].forEach((v) {
        receiptitemlist!.add(ReceiptItem.fromJson(v));
      });
    }
    totalprice = json['total_price'];
    datecreated = json['date_created'];
    employee = json['created_by'];
  }
}

class ReceiptItem {
  String? productName;
  String? productCode;
  String? productPrice;
  int? itemCount;

  ReceiptItem(
      {this.productName, this.productCode, this.productPrice, this.itemCount});

  ReceiptItem.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    productCode = json['product_code'];
    productPrice = json['product_price'];
    itemCount = json['item_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['product_name'] = productName;

    data['product_price'] = productPrice;
    data['item_count'] = itemCount;
    data['product_code'] = productCode;
    return data;
  }
}

class ReceiptModel {
  List<Receipt>? receipts;

  ReceiptModel({this.receipts});

  ReceiptModel.fromJson(Map<String, dynamic> json) {
    if (json['receipts'] != null) {
      receipts = <Receipt>[];
      json['receipts'].forEach((v) {
        receipts!.add(Receipt.fromJson(v));
      });
    }
  }
}
