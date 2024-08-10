import 'package:desktop/module/layout/cubit/cubit.dart';
import 'package:desktop/module/layout/cubit/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sidebarx/sidebarx.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            body: Row(
              children: [
                Expanded(
                  child: SidebarX(
                    controller: cubit.controller,
                    items: cubit.sideBar,
                    headerBuilder: (context, extended) {
                      return const SizedBox(
                        height: 40,
                      );
                    },
                    theme: const SidebarXTheme(
                        textStyle: TextStyle(color: CupertinoColors.white),
                        iconTheme: IconThemeData(color: Colors.white),
                        padding: EdgeInsets.all(20),
                        selectedIconTheme: CupertinoIconThemeData(
                            color: Colors.white, size: 30),
                        selectedTextStyle: TextStyle(
                            fontSize: 30, color: CupertinoColors.white),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                        )),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    child: cubit.screens[cubit.selectedIndex],
                  ),
                ),
              ],
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
