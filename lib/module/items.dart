import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:desktop/blocs/products_bloc/products_cubit.dart';
import 'package:desktop/blocs/products_bloc/products_states.dart';
import 'package:desktop/module/layout/cubit/cubit.dart';
import 'package:desktop/module/layout/cubit/state.dart';

class ItemsScreen extends StatelessWidget {
  const ItemsScreen({super.key});

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
                Text('قائمة المنتجات',style: TextStyle(color: CupertinoColors.white),),
              ],
            ),
            backgroundColor: Colors.teal[800],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Row(
                  children: [
                    Spacer(),
                    Expanded(
                      child: Center(
                        child: Text(
                          'مسح',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'اعدادات',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'السعر',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'الكود',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'الكمية',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'الاسم',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'التسلسل',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView.separated(
                    itemCount: cubit.productsModel!.products!.length,
                    itemBuilder: (context, index) => items(
                      model: cubit.productsModel!.products![index]!.toJson(),
                      context: context,
                    ),
                    separatorBuilder: (context, index) => const SizedBox(height: 1),
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
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
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
                            // Add your delete logic here
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
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return BlocProvider(
                      create: (context) => AppCubit()..createDatabase(),
                      child: BlocConsumer<AppCubit, AppStates>(
                        builder: (context, state) => Padding(
                          padding: const EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            child: Builder(builder: (context) {
                              nameController.text = model['product_name'];
                              priceController.text = model['product_price'];
                              amountController.text = model['product_quota'].toString();
                              codeController.text = model['product_code'].toString();
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
                                      BlocProvider.of<ProductsCubit>(context).updateProduct(
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
                                          style: TextStyle(fontSize: 20, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                        listener: (context, state) {},
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
