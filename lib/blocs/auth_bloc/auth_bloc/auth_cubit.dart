import 'package:desktop/services/apis/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../src/app_shared.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitial());
  static AuthCubit get(context) => BlocProvider.of(context);

  TextEditingController usernameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  String selectedRole = 'موظف';
  loginUser() async {
    emit(AuthLoading());
    AuthApi()
        .loginUser(
            password: passwordCont.text,
            username: usernameCont.text,
            role: selectedRole == 'موظف' ? 'employee' : 'admin')
        .then((value) {
      if (value['success'] == true) {
        emit(AuthSuccess(msg: value['message']));
        clearAndSave();
      } else if (value['success'] == false) {
        emit(AuthError(msg: value['message']));
      } else if (value == 'error') {
        emit(AuthError(msg: 'Check Internet Connection'));
      }
    });
  }

  clearAndSave() async {
    await AppShared.localStorage.setBool('active', true);
    await AppShared.localStorage.setString('username', usernameCont.text);
    passwordCont.clear();
    usernameCont.clear();
  }
}
