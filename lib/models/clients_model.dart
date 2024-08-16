class Client {
  String? id;
  String? clientname;
  String? clientphone;
  String? dateadded;

  Client({this.id, this.clientname, this.clientphone, this.dateadded});

  Client.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientname = json['client_name'];
    clientphone = json['client_phone'];
    dateadded = json['date_added'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['client_name'] = clientname;
    data['client_phone'] = clientphone;
    return data;
  }
}

class ClientsModel {
  bool? success;
  String? message;
  List<Client?>? clients;

  ClientsModel({this.success, this.message, this.clients});

  ClientsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['clients'] != null) {
      clients = <Client>[];
      json['clients'].forEach((v) {
        clients!.add(Client.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = success;
    data['message'] = message;
    data['clients'] =
        clients != null ? clients!.map((v) => v?.toJson()).toList() : null;
    return data;
  }
}
