import 'package:desktop/shared/bloc.dart';
import 'package:desktop/src/app_root.dart';
import 'package:desktop/src/app_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppShared.init();
  Bloc.observer = MyBlocObserver();
  runApp(const AppRoot());
}
