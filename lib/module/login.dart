import 'package:desktop/blocs/auth_bloc/auth_bloc/auth_cubit.dart';
import 'package:desktop/blocs/auth_bloc/auth_bloc/auth_states.dart';
import 'package:desktop/module/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(listener: (context, state) {
      if (state is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red.shade400,
          content: Text(
            state.msg,
            textAlign: TextAlign.center,
          ),
        ));
      }
      if (state is AuthSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green.shade400,
          content: Text(
            state.msg,
            textAlign: TextAlign.center,
          ),
        ));
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SplashScreen(),
            ));
      }
    }, builder: (context, state) {
      var cubit = AuthCubit.get(context);

      return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                color:
                    Colors.black.withOpacity(0.4), // semi-transparent overlay
              ),
            ),
            Center(
              child: Card(
                color: Colors.white.withOpacity(0.9),
                child: Container(
                  width: 500,
                  padding: const EdgeInsets.all(80),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.store,
                              size: 40,
                              color: Colors.teal[800],
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        DropdownButtonFormField<String>(
                          value: cubit.selectedRole,
                          items: ['أدمن', 'موظف'].map((role) {
                            return DropdownMenuItem(
                              value: role,
                              child: Row(
                                children: [
                                  Icon(
                                    role == 'أدمن'
                                        ? FontAwesomeIcons.userShield
                                        : FontAwesomeIcons.userTie,
                                    size: 20,
                                    color: Colors.teal[800],
                                  ),
                                  const SizedBox(width: 10),
                                  Text(role),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              cubit.selectedRole = value!;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'حدد الرتبة',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '*فارغ';
                            }
                            return null;
                          },
                          controller: cubit.usernameCont,
                          decoration: InputDecoration(
                            labelText: 'اسم المستخدم',
                            prefixIcon: Icon(
                              FontAwesomeIcons.idBadge,
                              color: Colors.teal[800],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '*فارغ';
                            }
                            return null;
                          },
                          controller: cubit.passwordCont,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'الرقم السري',
                            prefixIcon: Icon(
                              FontAwesomeIcons.lock,
                              color: Colors.teal[800],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              cubit.loginUser();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 30),
                            backgroundColor: Colors.teal[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                'تسجيل الدخول',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
