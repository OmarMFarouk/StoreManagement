/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/
class TreasuryModel {
  bool? success;
  String? message;
  List<Treasury>? treasury;

  TreasuryModel({this.success, this.message, this.treasury});

  TreasuryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['treasury'] != null) {
      treasury = <Treasury>[];
      json['treasury'].forEach((v) {
        treasury!.add(Treasury.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = success;
    data['message'] = message;
    data['treasury'] =
        treasury != null ? treasury!.map((v) => v.toJson()).toList() : null;
    return data;
  }
}

class Treasury {
  String? id;
  String? createdby;
  String? amount;
  String? type;
  String? comment;
  String? datecreated;

  Treasury(
      {this.id,
      this.createdby,
      this.amount,
      this.type,
      this.comment,
      this.datecreated});

  Treasury.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdby = json['created_by'];
    amount = json['amount'];
    type = json['type'];
    comment = json['comment'];
    datecreated = json['date_created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['created_by'] = createdby;
    data['amount'] = amount;
    data['comment'] = comment;
    data['type'] = type;
    return data;
  }
}
