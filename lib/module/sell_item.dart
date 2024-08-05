import 'package:desktop/blocs/products_bloc/products_cubit.dart';
import 'package:desktop/blocs/products_bloc/products_states.dart';
import 'package:desktop/models/products_model.dart';
import 'package:desktop/models/receipt_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SellItem extends StatefulWidget {
  const SellItem({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SellItemState createState() => _SellItemState();
}

class _SellItemState extends State<SellItem> {
  final List<Product> _searchResultData = [];
  final List<ReceiptItem> _cartProducts = [];
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  String searchKey = "";

  void getMatch({productsList}) {
    _searchResultData.clear();
    for (Product item in productsList) {
      if (item.productcode!
              .toLowerCase()
              .contains(_codeController.text.toLowerCase()) &&
          !_searchResultData.contains(item)) {
        setState(() => _searchResultData.add(item));
      }
      if (_codeController.text == "") {
        setState(() {
          _searchResultData.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = ProductsCubit.get(context);

    return BlocConsumer<ProductsCubit, ProductsStates>(
        listener: (context, state) {
      if (state is ReceiptCreated) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          state.msg,
          textAlign: TextAlign.center,
        )));
        _cartProducts.clear();
        _searchResultData.clear();
        sum = 0;
      }
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
        appBar: AppBar(
          title: const Row(
            children: [
              Spacer(),
              Text(
                'بيع المنتجات',
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            border: Border.all(
                              style: BorderStyle.solid,
                              color: CupertinoColors.black,
                              width: 0.2,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'اعدادات',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'الكمية فالمخزن',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'السعر',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'العدد',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'النوع',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        ListView.separated(
                          shrinkWrap: true,
                          itemCount: _cartProducts.length,
                          itemBuilder: (context, index) => Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: TextButton.icon(
                                        label: const Text(
                                          'إزالة',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _cartProducts
                                                .remove(_cartProducts[index]);
                                            calcSum(_cartProducts);
                                          });
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        remainder(cubit, index).toString(),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        (int.parse(_cartProducts[index]
                                                    .productPrice!) *
                                                _cartProducts[index].itemCount!)
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        _cartProducts[index].productCode !=
                                                'خصم'
                                            ? IconButton(
                                                onPressed: () {
                                                  if (_cartProducts[index]
                                                          .itemCount! <
                                                      int.parse(remainder(
                                                          cubit, index))) {
                                                    setState(() {
                                                      _cartProducts[index]
                                                              .itemCount =
                                                          _cartProducts[index]
                                                                  .itemCount! +
                                                              1;
                                                      calcSum(_cartProducts);
                                                    });
                                                  }
                                                },
                                                icon: Icon(
                                                  CupertinoIcons
                                                      .plus_circle_fill,
                                                  color: Colors.teal[800],
                                                ))
                                            : SizedBox(),
                                        Text(
                                          _cartProducts[index]
                                              .itemCount
                                              .toString(),
                                        ),
                                        _cartProducts[index].productCode !=
                                                'خصم'
                                            ? IconButton(
                                                onPressed: () {
                                                  if (_cartProducts[index]
                                                          .itemCount! >
                                                      1) {
                                                    setState(() {
                                                      _cartProducts[index]
                                                              .itemCount =
                                                          _cartProducts[index]
                                                                  .itemCount! -
                                                              1;
                                                      calcSum(_cartProducts);
                                                    });
                                                  }
                                                },
                                                icon: const Icon(
                                                  CupertinoIcons
                                                      .minus_circle_fill,
                                                  color: Colors.teal,
                                                ))
                                            : SizedBox(),
                                      ],
                                    )),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        _cartProducts[index].productName!,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                        textDirection: TextDirection.rtl,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (index + 1 == _cartProducts.length)
                                const SizedBox(height: 20),
                              if (index + 1 == _cartProducts.length)
                                Center(
                                  child: Text(
                                    'الاجمالي:  ${sum.toString()}',
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 30),
                                  ),
                                ),
                            ],
                          ),
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 10),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 60,
                          width: 250,
                          child: TextField(
                            controller: _codeController,
                            onChanged: (value) {
                              setState(() {
                                getMatch(
                                    productsList:
                                        cubit.productsModel!.products);
                              });
                            },
                            textDirection: TextDirection.rtl,
                            decoration: const InputDecoration(
                              label: Row(
                                children: [
                                  Spacer(),
                                  Text('الكود'),
                                ],
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: ListView.builder(
                            itemCount: _searchResultData.length,
                            itemBuilder: (context, index) => Row(
                              children: [
                                Expanded(
                                  child: TextButton.icon(
                                    label: const Text('ضف للعربة'),
                                    onPressed: () {
                                      if (!_cartProducts
                                          .map((e) => e.productCode)
                                          .contains(_searchResultData[index]
                                              .productcode)) {
                                        setState(() {
                                          _cartProducts.add(ReceiptItem(
                                              itemCount: 1,
                                              productCode:
                                                  _searchResultData[index]
                                                      .productcode,
                                              productName:
                                                  _searchResultData[index]
                                                      .productname,
                                              productPrice:
                                                  _searchResultData[index]
                                                      .productprice));

                                          _codeController.clear();
                                          _searchResultData.clear();
                                          calcSum(_cartProducts);
                                        });
                                      }
                                    },
                                    icon: const Icon(
                                        Icons.add_shopping_cart_outlined),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _searchResultData[index].productname!,
                                    style: const TextStyle(color: Colors.black),
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 300,
                        child: TextField(
                          controller: _discountController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onSubmitted: (value) {
                            setState(() {
                              if (value.isNotEmpty && sum > int.parse(value)) {
                                int discount = int.parse(value);
                                sum = sum - discount;
                                _cartProducts.add(ReceiptItem(
                                    itemCount: 1,
                                    productCode: 'خصم',
                                    productName: 'خصم',
                                    productPrice: '$discount'));
                                _discountController.clear();
                              }
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'الخصم',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {},
                              color: Colors.teal,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(15),
                                child: Text('بيع بفاتورة'),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: MaterialButton(
                              onPressed: () =>
                                  cubit.createReceipt(_cartProducts, sum),
                              color: Colors.teal,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(15),
                                child: Text('بيع بدون فاتورة'),
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

  remainder(cubit, index) {
    if (_cartProducts[index].productCode == 'خصم') {
      return '';
    } else {
      int indexer = cubit.productsModel!.products!.indexWhere((e) {
        return e!.productcode == _cartProducts[index].productCode;
      });
      return cubit.productsModel!.products[indexer]!.productquota;
    }
  }

  void calcSum(List<ReceiptItem> productList) {
    double ssum = 0;
    for (var i = 0; i < productList.length; i++) {
      if (productList[i].productCode != 'خصم') {
        double price = double.parse(productList[i].productPrice!) *
            productList[i].itemCount!;
        ssum += price;
      }
    }
    sum = ssum;
  }

  calcQuantity(List<Product> productList, productCode) {
    double quantity = 0;
    List has = productList;
    for (var i = 0; i < productList.length; i++) {
      if (has.map((e) => e.productcode).contains(productCode)) {
        quantity = quantity + 1;
      }
    }
    return quantity;
  }
}

double sum = 0;
