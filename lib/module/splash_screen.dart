import 'dart:async';

import 'package:desktop/blocs/employee_bloc/employee_cubit.dart';
import 'package:desktop/blocs/products_bloc/products_cubit.dart';
import 'package:desktop/module/layout/layoutScreen.dart';
import 'package:desktop/src/app_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  double size = 50;
  void initState() {
    _timer = Timer.periodic(
        Duration(milliseconds: 10),
        (s) => setState(() {
              size = size + 1;
            }));
    if (AppShared.localStorage.getBool('active') == true) {
      BlocProvider.of<ProductsCubit>(context).fetchProducts();
      BlocProvider.of<ProductsCubit>(context).fetchReceipts();
      BlocProvider.of<EmployeeCubit>(context).fetchEmployees();
      BlocProvider.of<EmployeeCubit>(context).fetchCurrentEmployeeData();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
          Duration(seconds: 3),
          () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LayoutScreen(),
              )));
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Icon(
          Icons.store,
          size: size,
        ),
      ),
    );
  }
}
