import 'package:desktop/models/employee_model.dart';
import 'package:desktop/services/apis/employee_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'employee_states.dart';

class EmployeeCubit extends Cubit<EmployeeStates> {
  EmployeeCubit() : super(EmployeeInitial());
  static EmployeeCubit get(context) => BlocProvider.of(context);

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  EmployeesModel employeesModel = EmployeesModel();

  fetchCurrentEmployeeData() async {
    EmployeesApi().fetchCurrentEmployeeData().then((r) {
      if (r['success'] == true) {
        currentEmployee = Employee.fromJson(r['user_data']);
        emit(EmployeeLoaded());
      } else if (r['success'] == false) {
        emit(EmployeeFailure(msg: r['message']));
      } else {
        emit(EmployeeFailure(msg: 'Error'));
      }
    });
  }

  fetchEmployees() async {
    EmployeesApi().fetchEmployees().then((r) {
      if (r['success'] == true) {
        employeesModel = EmployeesModel.fromJson(r);
        emit(EmployeeLoaded());
      } else if (r['success'] == false) {
        emit(EmployeeFailure(msg: r['message']));
      } else {
        emit(EmployeeFailure(msg: 'Error'));
      }
    });
  }

  createEmployee() async {
    EmployeesApi()
        .createEmployee(
            model: Employee(
                    username: usernameController.text,
                    password: passwordController.text)
                .toJson())
        .then((r) {
      if (r['success'] == true) {
        emit(EmployeeCreated());
        fetchEmployees();
        clearControllers();
      } else if (r['success'] == false) {
        emit(EmployeeFailure(msg: r['message']));
      } else {
        emit(EmployeeFailure(msg: 'Error'));
      }
    });
  }

  clearControllers() {
    usernameController.clear();
    passwordController.clear();
  }
}

late Employee currentEmployee;
