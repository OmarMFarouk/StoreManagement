import 'package:desktop/blocs/auth_bloc/auth_bloc/auth_cubit.dart';
import 'package:desktop/blocs/employee_bloc/employee_cubit.dart';
import 'package:desktop/blocs/products_bloc/products_cubit.dart';
import 'package:desktop/module/login.dart';
import 'package:desktop/module/splash_screen.dart';
import 'package:desktop/shared/bloc.dart';
import 'package:desktop/src/app_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppShared.init();
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => ProductsCubit()
              ..fetchProducts()
              ..fetchReceipts()),
        BlocProvider(create: (context) => EmployeeCubit()..fetchEmployees()),
        BlocProvider(create: (context) => AuthCubit())
      ],
      child: MaterialApp(
        title: 'Store Management',
        debugShowCheckedModeBanner: false,
        home: AppShared.localStorage.getBool('active') == true
            ? SplashScreen()
            : LoginScreen(),
      ),
    );
  }
}
