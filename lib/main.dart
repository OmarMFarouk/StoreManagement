import 'package:bloc/bloc.dart';
import 'package:desktop/blocs/products_bloc/products_cubit.dart';
import 'package:desktop/shared/bloc.dart';
import 'package:desktop/src/app_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'module/layout/layoutScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppShared.init();
  Bloc.observer = MyBlocObserver();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
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
              ..fetchReceipts())
      ],
      child: const MaterialApp(
        title: 'Store Management',
        debugShowCheckedModeBanner: false,
        home: LayoutScreen(),
      ),
    );
  }
}
