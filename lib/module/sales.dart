import 'package:desktop/blocs/products_bloc/products_cubit.dart';
import 'package:desktop/blocs/products_bloc/products_states.dart';
import 'package:desktop/src/exp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../models/receipt_model.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final TextEditingController _dateController = TextEditingController();
  List<Receipt> _salesByDate = [];

  double _totalPrice = 0.0;
  DateTime? pickedDate;
  void _fetchSalesData(List<Receipt> salesData) async {
    _salesByDate.isNotEmpty ? _salesByDate.clear() : null;
    for (var i = 0; i < salesData.length; i++) {
      if (DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.parse(
                      salesData[i].datecreated!.replaceRange(10, 19, ''))))
                  .day ==
              pickedDate!.day &&
          !_salesByDate.contains(salesData[i])) {
        setState(() {
          _salesByDate.add(salesData[i]);
        });
        print('nigga $_salesByDate');
      }
    }
  }

  @override
  void initState() {
    BlocProvider.of<ProductsCubit>(context).fetchReceipts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsCubit, ProductsStates>(
        listener: (context, state) {
      if (state is ProductsFailure) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          state.msg,
          textAlign: TextAlign.center,
        )));
      }
    }, builder: (context, state) {
      var cubit = ProductsCubit.get(context);
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.calendar_today),
                        labelText: 'التاريخ',
                      ),
                      onTap: () async {
                        pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );

                        _fetchSalesData(cubit.receiptModel!.receipts!);
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () {},
                    child: const Text('بحث'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'إجمالي الأسعار: $_totalPrice',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                  child: cubit.receiptModel == null
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : _salesByDate.isEmpty
                          ? ListView.builder(
                              itemCount: cubit.receiptModel!.receipts!.length,
                              itemBuilder: (context, index) {
                                var sale = cubit.receiptModel!.receipts![index];
                                return MyExpansion(
                                  content: SizedBox(
                                    height: 250,
                                    child: ListView.builder(
                                      itemCount: cubit
                                          .receiptModel!
                                          .receipts![index]
                                          .receiptitemlist!
                                          .length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, itemIndex) =>
                                          ListTile(
                                        title: Text(sale
                                                .receiptitemlist![itemIndex]!
                                                .itemCount!
                                                .toString() +
                                            '\tالعدد\t' +
                                            sale.receiptitemlist![itemIndex]!
                                                .productName!),
                                        subtitle: Text(sale
                                            .receiptitemlist![itemIndex]!
                                            .productCode!),
                                        trailing: Text(sale
                                                .receiptitemlist![itemIndex]!
                                                .productPrice! +
                                            ' السعر'),
                                      ),
                                    ),
                                  ),
                                  title:
                                      ' فاتوره رقم ${sale.id}  بتاريخ ${sale.datecreated}   الأجمالي ${sale.totalprice} جنية',
                                );
                              },
                            )
                          : ListView.builder(
                              itemCount: _salesByDate.length,
                              itemBuilder: (context, index) {
                                var sale = _salesByDate[index];
                                return MyExpansion(
                                  content: SizedBox(
                                    height: 250,
                                    child: ListView.builder(
                                      itemCount: _salesByDate[index]
                                          .receiptitemlist!
                                          .length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, itemIndex) =>
                                          ListTile(
                                        title: Text(sale
                                                .receiptitemlist![itemIndex]!
                                                .itemCount!
                                                .toString() +
                                            '\tالعدد\t' +
                                            sale.receiptitemlist![itemIndex]!
                                                .productName!),
                                        subtitle: Text(sale
                                            .receiptitemlist![itemIndex]!
                                            .productCode!),
                                        trailing: Text(sale
                                                .receiptitemlist![itemIndex]!
                                                .productPrice! +
                                            ' السعر'),
                                      ),
                                    ),
                                  ),
                                  title:
                                      ' فاتوره رقم ${sale.id}  بتاريخ ${sale.datecreated}   الأجمالي ${sale.totalprice} جنية',
                                );
                              },
                            )),
            ],
          ),
        ),
      );
    });
  }
}
