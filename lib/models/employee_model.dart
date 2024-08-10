/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/
class Employee {
  String? id;
  String? username;
  String? password;
  String? lastaccess;
  String? datecreated;
  String? role;

  Employee(
      {this.id,
      this.username,
      this.password,
      this.lastaccess,
      this.datecreated,
      this.role});

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    password = json['password'];
    lastaccess = json['last_access'];
    datecreated = json['date_created'];
    role = json['role'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['username'] = username;
    data['password'] = password;
    return data;
  }
}

class EmployeesModel {
  bool? success;
  String? message;
  List<Employee?>? employees;

  EmployeesModel({this.success, this.message, this.employees});

  EmployeesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['employees'] != null) {
      employees = <Employee>[];
      json['employees'].forEach((v) {
        employees!.add(Employee.fromJson(v));
      });
    }
  }
}
