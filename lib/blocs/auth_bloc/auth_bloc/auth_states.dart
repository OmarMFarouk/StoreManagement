abstract class AuthStates {}

class AuthInitial extends AuthStates {}

class AuthRefresh extends AuthStates {}

class AuthLoading extends AuthStates {}

class AuthSuccess extends AuthStates {
  String msg = '';
  AuthSuccess({required this.msg});
}

class AuthError extends AuthStates {
  String msg = '';
  AuthError({required this.msg});
}
