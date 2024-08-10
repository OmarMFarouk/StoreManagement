import 'package:desktop/models/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/employee_bloc/employee_cubit.dart';
import '../blocs/employee_bloc/employee_states.dart';

class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
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
      if (state is EmployeeCreated) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green.shade400,
          content: Text(
            'تم اضافة الموظف',
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '*فارغ';
                          } else if (value.length < 6) {
                            return '*الرقم السري قصير';
                          }
                          return null;
                        },
                        controller: cubit.passwordController,
                        textDirection: TextDirection.rtl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Row(
                            children: [
                              Spacer(),
                              Text('كلمة المرور'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '*فارغ';
                          }
                          return null;
                        },
                        controller: cubit.usernameController,
                        textDirection: TextDirection.rtl,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Row(
                            children: [
                              Spacer(),
                              Text('اسم المستخدم'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      cubit.createEmployee();
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.teal[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'اضافة',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(height: 1, color: Colors.grey),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: cubit.employeesModel.employees!.length,
                    itemBuilder: (context, index) {
                      Employee employee =
                          cubit.employeesModel.employees![index]!;
                      return ListTile(
                        title: Text(employee.username!,
                            textDirection: TextDirection.rtl),
                        subtitle: Text(
                            'اخر تسجيل دخول : ' + employee.lastaccess!,
                            textDirection: TextDirection.rtl),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // EmployeeCubit.get(context)
                            //     .deleteEmployee(employee.id!);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
