/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/
class Product {
  String? id;
  String? productname;
  String? productcode;
  String? productprice;
  String? productquota;
  String? productimage;
  String? dateadded;

  Product(
      {this.id,
      this.productname,
      this.productcode,
      this.productprice,
      this.productquota,
      this.productimage,
      this.dateadded});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productname = json['product_name'];
    productcode = json['product_code'];
    productprice = json['product_price'];
    productquota = json['product_quota'];
    productimage = json['product_image'];
    dateadded = json['date_added'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_name'] = productname;
    data['product_code'] = productcode;
    data['product_price'] = productprice;
    data['product_quota'] = productquota;
    data['product_image'] = productimage;
    return data;
  }
}

class ProductsModel {
  bool? success;
  String? message;
  List<Product?>? products;

  ProductsModel({this.success, this.message, this.products});

  ProductsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['products'] != null) {
      products = <Product>[];
      json['products'].forEach((v) {
        products!.add(Product.fromJson(v));
      });
    }
  }
}
