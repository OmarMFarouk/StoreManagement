import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/employee_bloc/employee_cubit.dart';
import '../blocs/employee_bloc/employee_states.dart';

class EmployeeDataScreen extends StatelessWidget {
  const EmployeeDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmployeeCubit, EmployeeStates>(
        listener: (context, state) {
      if (state is EmployeeFailure) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red.shade400,
          content: Text(
            state.msg,
            textAlign: TextAlign.center,
          ),
        ));
      }
      if (state is EmployeeSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green.shade400,
          content: Text(
            state.msg,
            textAlign: TextAlign.center,
          ),
        ));
      }
    }, builder: (context, state) {
      var cubit = EmployeeCubit.get(context);
      return Scaffold(
        appBar: AppBar(
          title: const Text('ادارة الموظفين',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.teal[800],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [],
          ),
        ),
      );
    });
  }
}
