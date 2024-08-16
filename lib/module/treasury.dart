import 'package:desktop/blocs/employee_bloc/employee_cubit.dart';
import 'package:desktop/blocs/employee_bloc/employee_states.dart';
import 'package:desktop/models/treasury_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TreasuryScreen extends StatefulWidget {
  const TreasuryScreen({super.key});

  @override
  State<TreasuryScreen> createState() => _TreasuryScreenState();
}

class _TreasuryScreenState extends State<TreasuryScreen> {
  @override
  @override
  void initState() {
    BlocProvider.of<EmployeeCubit>(context).fetchTreasury();
    super.initState();
  }

  Widget build(BuildContext context) {
    return BlocConsumer<EmployeeCubit, EmployeeStates>(
        listener: (context, state) {
      if (state is EmployeeSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              state.msg,
              textAlign: TextAlign.center,
            )));
      }
      if (state is EmployeeFailure) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              state.msg,
              textAlign: TextAlign.center,
            )));
      }
    }, builder: (context, state) {
      final formKey = GlobalKey<FormState>();
      var cubit = EmployeeCubit.get(context);
      return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text(
            'الخزينة',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.teal[800],
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const Text(
                        'المبلغ المتوفر بلخزنة',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        sumBalance(cubit.treasuryModel!.treasury!) +
                            '\tجنية', // Example balance, should be dynamically loaded

                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: cubit.amountController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '*فارغ';
                          } else if (int.parse(value) == 0) {
                            return '*المبلغ غير صحيح';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.attach_money_outlined,
                              color: Colors.teal, size: 28),
                          label: Row(
                            children: [Spacer(), Text('المبلغ')],
                          ),
                          labelStyle: TextStyle(color: Colors.teal),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal),
                          ),
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: cubit.usernameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '*فارغ';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon:
                              Icon(Icons.comment, color: Colors.teal, size: 28),
                          label: Row(
                            children: [Spacer(), Text('ملاحظات')],
                          ),
                          labelStyle: TextStyle(color: Colors.teal),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal),
                          ),
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.treasuryRequest(isWithdraw: false);
                                  }
                                },
                                icon: const Icon(
                                  Icons.arrow_upward_rounded,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'إيداع',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  backgroundColor: Colors.teal[800],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.treasuryRequest(isWithdraw: true);
                                  }
                                },
                                icon: const Icon(
                                  Icons.arrow_downward_rounded,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'سحب',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  backgroundColor: Colors.teal[800],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

sumBalance(List<Treasury> treasuryList) {
  int total = 0;
  for (var i = 0; i < treasuryList.length; i++) {
    int price = int.parse(treasuryList[i].amount!);
    if (treasuryList[i].type == 'income') {
      total = total + price;
    } else {
      total = total - price;
    }
  }
  return total.toString();
}
