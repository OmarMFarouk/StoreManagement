import 'package:desktop/module/addItem.dart';
import 'package:desktop/module/clientsData.dart';
import 'package:desktop/module/employee_data.dart';
import 'package:desktop/module/employees.dart';
import 'package:desktop/module/layout/cubit/state.dart';
import 'package:desktop/module/printing.dart';
import 'package:desktop/module/return_data.dart';
import 'package:desktop/module/sell_item.dart';
import 'package:desktop/module/splash_screen.dart';
import 'package:desktop/src/app_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:restartfromos/restartatos.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:sqflite/sqflite.dart';
import '../../../blocs/employee_bloc/employee_cubit.dart';
import '../../items.dart';
import '../../sales.dart';
import '../../treasury.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState()) {
    controller = SidebarXController(
      selectedIndex: 0,
      extended: true,
    );
    controller.addListener(() {
      selectedIndex = controller.selectedIndex;
      emit(AppChangeIndexState());
    });
  }

  static AppCubit get(context) => BlocProvider.of(context);

  int selectedIndex = 0;
  late SidebarXController controller;

  List<SidebarXItem> sideBar = [
    const SidebarXItem(icon: Icons.sell, label: ' بيع'),
    const SidebarXItem(icon: Icons.add, label: ' اضافة'),
    const SidebarXItem(icon: Icons.category_rounded, label: ' المبيعات'),
    const SidebarXItem(icon: Icons.data_object, label: ' البضاعة'),
    const SidebarXItem(icon: Icons.assignment_return, label: ' المرتجعات'),
    const SidebarXItem(
        icon: FontAwesomeIcons.codePullRequest, label: ' الخزينة'),
    currentEmployee.role == 'admin'
        ? const SidebarXItem(icon: Icons.people, label: ' الموظفين')
        : const SidebarXItem(icon: Icons.people, label: ' بياناتي'),
    const SidebarXItem(icon: Icons.man_3, label: ' عملاء'),
    // const SidebarXItem(icon: Icons.print, label: ' طباعة'),
    SidebarXItem(
      icon: Icons.logout,
      label: ' تسجيل خروج',
      onTap: () async {
        await AppShared.localStorage.setBool('active', false);
        RestartFromOS.restartApp(appName: 'desktop');
      },
    ),
  ];

  List<Widget> screens = [
    const SellItem(),
    const AddItem(),
    const SalesScreen(),
    const ItemsScreen(),
    const ReturnScreen(),
    const TreasuryScreen(),
    currentEmployee.role == 'admin'
        ? const EmployeeScreen()
        : const EmployeeDataScreen(),
    const AddClients(),
    // const PrintingScreen(),
    const SplashScreen(),
  ];

  Database? database;

  List<Map> data = [];

  void createDatabase() {
    openDatabase(
      'store.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
                'CREATE TABLE data(id INTEGER PRIMARY KEY, name TEXT, amount INTEGER, code TEXT, price TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        print('database opened');
        database
            .execute('ALTER TABLE data ADD COLUMN discount TEXT')
            .then((value) {
          print('column added');
        }).catchError((error) {
          if (!error.toString().contains('duplicate column name')) {
            print('Error Adding Column ${error.toString()}');
          }
        });
        getDatabase(database);
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  Future insertDatabase({
    required String name,
    required amount,
    required String code,
    required String price,
    required String discount,
  }) async {
    return await database?.transaction((txn) async {
      txn.rawInsert(
          'INSERT INTO data(name, amount, code, price, discount) VALUES(?, ?, ?, ?, ?)',
          [name, amount, code, price, discount]).then((value) {
        print("$value inserted into database");
        emit(AppInsertDatabaseState());
        getDatabase(database);
      }).catchError((error) {
        print('Error Inserting $error');
      });
    });
  }

  void getDatabase(database) {
    database.rawQuery('SELECT * FROM data').then((value) {
      data = value;
      print(data);
      emit(AppGetDatabaseState());
    });
  }

  void updateDatabase(
      {required String name,
      required amount,
      required String code,
      required String price,
      required int id}) {
    database?.rawUpdate(
        'UPDATE data SET name = ?, amount = ?, code = ?, price = ? WHERE id = ?',
        [name, amount, code, price, id]).then((value) {
      getDatabase(database);
      emit(AppUpdateDatabase());
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  void deleteDatabase({required int id}) async {
    database?.rawDelete('DELETE FROM data WHERE id = ?', [id]).then((value) {
      getDatabase(database);
      emit(AppDeleteDatabase());
    });
  }

  Future<Map?> getItemByCode(String code) async {
    List<Map> result =
        await database?.rawQuery('SELECT * FROM data WHERE code = ?', [code]) ??
            [];
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  void updateQuantity(String code, int amount, String discount) {
    var date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    database?.rawUpdate(
      'UPDATE data SET amount = amount - ?, date = ?, discount = ? WHERE code = ?',
      [amount, date, discount, code],
    ).then((value) {
      getDatabase(database);
      emit(AppUpdateDatabase());
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Future<List<Map>> getSalesByDate(String date) async {
    return await database
            ?.rawQuery('SELECT * FROM data WHERE date = ?', [date]) ??
        [];
  }
}
