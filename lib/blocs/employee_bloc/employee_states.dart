abstract class EmployeeStates {}

class EmployeeInitial extends EmployeeStates {}

class EmployeeLoading extends EmployeeStates {}

class EmployeeLoaded extends EmployeeStates {}

class EmployeeSuccess extends EmployeeStates {
  String msg = '';
  EmployeeSuccess({required this.msg});
}

class EmployeeFailure extends EmployeeStates {
  String msg = '';
  EmployeeFailure({required this.msg});
}
