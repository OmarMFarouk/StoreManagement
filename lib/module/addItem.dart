import 'package:desktop/blocs/products_bloc/products_cubit.dart';
import 'package:desktop/blocs/products_bloc/products_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddItem extends StatelessWidget {
  const AddItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsCubit, ProductsStates>(
      listener: (context, state) {
        if (state is ProductAdded) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'تم الأضافة',
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
            title: Row(
              children: [
                Spacer(),
                const Text('إضافة منتج',style: TextStyle(color: CupertinoColors.white),),
              ],
            ),
            backgroundColor: Colors.teal[800],
          ),
          body: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: cubit.nameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.label, color: Colors.teal),
                    label: const Row(
                      children: [Spacer(), Text('الاسم')],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: cubit.quantityController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(CupertinoIcons.number_circle_fill, color: Colors.teal),
                    label: const Row(
                      children: [Spacer(), Text('الكمية')],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: cubit.codeController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.code, color: Colors.teal),
                    label: const Row(
                      children: [Spacer(), Text('الكود')],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: cubit.priceController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.attach_money, color: Colors.teal),
                    label: const Row(
                      children: [Spacer(), Text('السعر')],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    cubit.addProduct();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.teal[800],
                    ),
                    child: const Center(
                      child: Text(
                        "إضافة",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
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
