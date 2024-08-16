abstract class ClientsStates {}

class ClientsInitial extends ClientsStates {}

class ClientsRefresh extends ClientsStates {}

class ClientsLoading extends ClientsStates {}

class ClientsSuccess extends ClientsStates {
  String msg = '';
  ClientsSuccess({required this.msg});
}

class ClientsError extends ClientsStates {
  String msg = '';
  ClientsError({required this.msg});
}
