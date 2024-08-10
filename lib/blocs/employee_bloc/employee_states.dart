abstract class EmployeeStates {}

class EmployeeInitial extends EmployeeStates {}

class EmployeeLoading extends EmployeeStates {}

class EmployeeLoaded extends EmployeeStates {}

class EmployeeCreated extends EmployeeStates {}

class EmployeeFailure extends EmployeeStates {
  String msg = '';
  EmployeeFailure({required this.msg});
}
