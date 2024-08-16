import 'package:desktop/blocs/products_bloc/products_cubit.dart';
import 'package:desktop/blocs/products_bloc/products_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../components/expansion_tile.dart';
import '../models/receipt_model.dart';

class ReturnScreen extends StatefulWidget {
  const ReturnScreen({super.key});

  @override
  _ReturnScreenState createState() => _ReturnScreenState();
}

class _ReturnScreenState extends State<ReturnScreen> {
  final TextEditingController _dateController = TextEditingController();
  final List<Receipt> _salesByDate = [];
  double _totalPrice = 0.0;
  DateTime? pickedDate;

  void _fetchSalesData(List<Receipt> salesData) {
    _salesByDate.clear();
    _totalPrice = 0.0;

    for (var sale in salesData) {
      var saleDate = DateTime.parse(sale.datecreated!.substring(0, 10));
      if (pickedDate != null && saleDate == pickedDate) {
        _salesByDate.add(sale);
        _totalPrice += double.tryParse(sale.totalprice ?? '0.0') ?? 0.0;
      }
    }

    setState(() {});
  }

  @override
  void initState() {
    BlocProvider.of<ProductsCubit>(context).fetchReceipts();
    pickedDate =
        DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    _fetchSalesData(
        BlocProvider.of<ProductsCubit>(context).returnModel!.receipts!);

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
            ),
          ));
        }
      },
      builder: (context, state) {
        var cubit = ProductsCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal[800],
            title: const Row(
              children: [
                Spacer(),
                Text(
                  'المبيعات',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.calendar_today),
                          labelText: 'التاريخ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onTap: () async {
                          pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );

                          if (pickedDate != null) {
                            _dateController.text =
                                DateFormat('yyyy-MM-dd').format(pickedDate!);
                            _fetchSalesData(cubit.returnModel!.receipts!);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (pickedDate != null) {
                          _fetchSalesData(cubit.returnModel!.receipts!);
                        }
                      },
                      child: const Text('بحث'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'إجمالي الأسعار: $_totalPrice جنية',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: cubit.returnModel == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : _salesByDate.isEmpty
                          ? const Center(
                              child: Text(
                                'لا توجد مبيعات لهذا التاريخ',
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _salesByDate.length,
                              itemBuilder: (context, index) {
                                var sale = _salesByDate[index];
                                return MyExpansion(
                                  content: SizedBox(
                                    height: 250,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          const Row(
                                            children: [
                                              Spacer(),
                                              Expanded(
                                                child: Text(
                                                  'الكود',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'السعر',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'العدد',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'النوع',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Expanded(
                                            child: ListView.separated(
                                              itemCount:
                                                  sale.receiptitemlist!.length,
                                              itemBuilder:
                                                  (context, itemIndex) => Row(
                                                children: [
                                                  const Spacer(),
                                                  Expanded(
                                                    child: Text(
                                                      sale
                                                          .receiptitemlist![
                                                              itemIndex]!
                                                          .productCode!,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      sale
                                                          .receiptitemlist![
                                                              itemIndex]!
                                                          .productPrice!,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '${sale.receiptitemlist![itemIndex]!.itemCount}',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      sale
                                                          .receiptitemlist![
                                                              itemIndex]!
                                                          .productName!,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              separatorBuilder:
                                                  (BuildContext context,
                                                          int index) =>
                                                      const SizedBox(
                                                height: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  title:
                                      ' فاتوره رقم ${sale.id}  بتاريخ ${sale.datecreated}   الأجمالي ${sale.totalprice} جنيه',
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
