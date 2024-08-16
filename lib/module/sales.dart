import 'package:desktop/blocs/products_bloc/products_cubit.dart';
import 'package:desktop/blocs/products_bloc/products_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../components/expansion_tile.dart';
import '../models/receipt_model.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
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
        BlocProvider.of<ProductsCubit>(context).receiptModel!.receipts!);

    super.initState();
  }

  Future<void> _printReceipt(Receipt receipt) async {
    final pdf = pw.Document();
    var font = await PdfGoogleFonts.cairoBold();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Receipt No: ${receipt.id}',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text('Date: ${receipt.datecreated}'),
              pw.SizedBox(height: 20),
              pw.Text(
                'Items:',
                style: const pw.TextStyle(fontSize: 18),
              ),
              pw.TableHelper.fromTextArray(
                headers: ['Name', 'Price', 'Quantity'],
                cellStyle: pw.TextStyle(
                  font: font,
                ),
                tableDirection: pw.TextDirection.rtl,
                data: receipt.receiptitemlist!.map((item) {
                  return [
                    item?.productName,
                    item?.productPrice,
                    item?.itemCount.toString(),
                  ];
                }).toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Total Price: ${receipt.totalprice} جنية',
                  style: pw.TextStyle(
                    font: font,
                  ),
                  textDirection: pw.TextDirection.rtl),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
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
                            _fetchSalesData(cubit.receiptModel!.receipts!);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (pickedDate != null) {
                          _fetchSalesData(cubit.receiptModel!.receipts!);
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
                  child: cubit.receiptModel == null
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
                                  content: Column(
                                    children: [
                                      SizedBox(
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
                                                  itemCount: sale
                                                      .receiptitemlist!.length,
                                                  itemBuilder:
                                                      (context, itemIndex) =>
                                                          Row(
                                                    children: [
                                                      const Spacer(),
                                                      Expanded(
                                                        child: Text(
                                                          sale
                                                              .receiptitemlist![
                                                                  itemIndex]!
                                                              .productCode!,
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 16),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          sale
                                                              .receiptitemlist![
                                                                  itemIndex]!
                                                              .productPrice!,
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 16),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          '${sale.receiptitemlist![itemIndex]!.itemCount}',
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 16),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          sale
                                                              .receiptitemlist![
                                                                  itemIndex]!
                                                              .productName!,
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
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
                                      ElevatedButton.icon(
                                        onPressed: () => _printReceipt(sale),
                                        icon: const Icon(Icons.print),
                                        label: const Text('طباعة الفاتورة'),
                                      ),
                                    ],
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
