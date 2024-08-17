import 'package:desktop/models/products_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:desktop/blocs/products_bloc/products_cubit.dart';
import 'package:desktop/blocs/products_bloc/products_states.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../blocs/employee_bloc/employee_cubit.dart';
import '../models/receipt_model.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final _searchData = [];
  void getMatch({productsList, keWoyrd}) {
    _searchData.clear();
    for (Product item in productsList) {
      if (item.productcode!.toLowerCase().contains(keWoyrd.toLowerCase()) ||
          item.productname!.toLowerCase().contains(keWoyrd.toLowerCase()) &&
              !_searchData.contains(item)) {
        setState(() => _searchData.add(item));
      }
      if (keWoyrd == "") {
        setState(() {
          _searchData.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsCubit, ProductsStates>(
      listener: (context, state) {
        if (state is ProductUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'تم التعديل',
              textAlign: TextAlign.center,
            ),
          ));
        }
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
            title: const Row(
              children: [
                Spacer(),
                Text(
                  'قائمة المنتجات',
                  style: TextStyle(color: CupertinoColors.white),
                ),
              ],
            ),
            backgroundColor: Colors.teal[800],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  textDirection: TextDirection.rtl,
                  onChanged: (value) {
                    getMatch(
                        productsList: cubit.productsModel!.products,
                        keWoyrd: value);
                  },
                  decoration: const InputDecoration(
                    label: Row(
                      children: [Spacer(), Text('بحث بالاسم او الكود')],
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Spacer(),
                    Expanded(
                      child: Center(
                        child: Text(
                          'طباعة',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'مسح',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'اعدادات',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'السعر',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'الكود',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'الكمية',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'الاسم',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'التسلسل',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: _searchData.isEmpty
                      ? ListView.separated(
                          itemCount: cubit.productsModel!.products!.length,
                          itemBuilder: (context, index) => items(
                            model:
                                cubit.productsModel!.products![index]!.toJson(),
                            context: context,
                          ),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 1),
                        )
                      : ListView.separated(
                          itemCount: _searchData.length,
                          itemBuilder: (context, index) => items(
                            model: _searchData[index]!.toJson(),
                            context: context,
                          ),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 1),
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

Widget items({required Map model, context}) {
  var nameController = TextEditingController();
  var priceController = TextEditingController();
  var codeController = TextEditingController();
  var amountController = TextEditingController();

  return Container(
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.symmetric(vertical: 5),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      children: [
        const Spacer(),
        Expanded(
          child: Center(
            child: IconButton(
                icon: const Icon(Icons.local_printshop_rounded,
                    color: Colors.teal),
                onPressed: () => _printReceipt(
                    Product.fromJson(model as Map<String, dynamic>))),
          ),
        ),
        Expanded(
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                if (currentEmployee.role != 'admin') {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'خارج صلاحيات الحساب',
                      textAlign: TextAlign.center,
                    ),
                  ));
                } else
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('تنبيه'),
                        content: const Text('هل تريد ان تحذف هذا المنتج؟'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('نعم'),
                            onPressed: () {
                              BlocProvider.of<ProductsCubit>(context)
                                  .deleteProduct(
                                      productCode: model['product_code']);
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('لا'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
              },
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                if (currentEmployee.role != 'admin') {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'خارج صلاحيات الحساب',
                      textAlign: TextAlign.center,
                    ),
                  ));
                } else
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          child: Builder(builder: (context) {
                            nameController.text = model['product_name'];
                            priceController.text = model['product_price'];
                            amountController.text =
                                model['product_quota'].toString();
                            codeController.text =
                                model['product_code'].toString();
                            return Column(
                              children: [
                                const Center(
                                  child: Text(
                                    'تعديل',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                TextField(
                                  controller: nameController,
                                  textAlign: TextAlign.right,
                                  decoration: const InputDecoration(
                                    label: Row(
                                      children: [Spacer(), Text('إلاسم')],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  controller: amountController,
                                  textAlign: TextAlign.right,
                                  decoration: const InputDecoration(
                                    label: Row(
                                      children: [Spacer(), Text('الكمية')],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  controller: codeController,
                                  enabled: false,
                                  textAlign: TextAlign.right,
                                  decoration: const InputDecoration(
                                    label: Row(
                                      children: [Spacer(), Text('كود')],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  controller: priceController,
                                  textAlign: TextAlign.right,
                                  decoration: const InputDecoration(
                                    label: Row(
                                      children: [Spacer(), Text('السعر')],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextButton(
                                  onPressed: () {
                                    BlocProvider.of<ProductsCubit>(context)
                                        .updateProduct(
                                      name: nameController.text,
                                      quota: amountController.text,
                                      code: codeController.text,
                                      price: priceController.text,
                                      id: model['id'],
                                    );
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.blue[800],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'تعديل',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      );
                    },
                  );
              },
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              model['product_price'],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              model['product_code'].toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              model['product_quota'].toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              model['product_name'],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              model['id'].toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    ),
  );
}

Future<void> _printReceipt(Product product) async {
  final pdf = pw.Document();
  var font = await PdfGoogleFonts.cairoBold();
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.TableHelper.fromTextArray(
                headers: ['Name', 'Price', 'Quantity', 'Code'],
                cellStyle: pw.TextStyle(
                  font: font,
                ),
                tableDirection: pw.TextDirection.rtl,
                data: [
                  [
                    product.productname,
                    product.productprice,
                    product.productquota,
                    product.productcode
                  ]
                ]),
            pw.SizedBox(height: 20),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}
