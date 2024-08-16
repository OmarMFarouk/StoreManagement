import 'package:desktop/blocs/clients_bloc/clients_cubit.dart';
import 'package:desktop/src/app_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_bloc/auth_bloc/auth_cubit.dart';
import '../blocs/employee_bloc/employee_cubit.dart';
import '../blocs/products_bloc/products_cubit.dart';
import '../module/login.dart';
import '../module/splash_screen.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => ProductsCubit()
              ..fetchProducts()
              ..fetchReceipts()
              ..fetchReturns()),
        BlocProvider(
            create: (context) => EmployeeCubit()
              ..fetchEmployees()
              ..fetchTreasury()),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => ClientsCubit()..fetchClients())
      ],
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'Cairo'),
        title: 'Store Management',
        debugShowCheckedModeBanner: false,
        home: AppShared.localStorage.getBool('active') == true
            ? SplashScreen()
            : LoginScreen(),
      ),
    );
  }
}
