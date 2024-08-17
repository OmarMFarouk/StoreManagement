import 'package:desktop/blocs/clients_bloc/Clients_states.dart';
import 'package:desktop/blocs/clients_bloc/clients_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddClients extends StatefulWidget {
  const AddClients({super.key});

  @override
  State<AddClients> createState() => _AddClientsState();
}

class _AddClientsState extends State<AddClients> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientsCubit, ClientsStates>(
        listener: (context, state) {
      if (state is ClientsSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              state.msg,
              textAlign: TextAlign.center,
            )));
      }
      if (state is ClientsError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              state.msg,
              textAlign: TextAlign.center,
            )));
      }
    }, builder: (context, state) {
      var cubit = ClientsCubit.get(context);
      return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Row(
            children: [
              Spacer(),
              Text('ادارة العملاء',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          backgroundColor: Colors.teal[800],
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            maxLength: 15,
                            buildCounter: (context,
                                {required currentLength,
                                required isFocused,
                                required maxLength}) {
                              return null;
                            },
                            controller: cubit.phoneCont,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '*فارغ';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9+]')),
                              FilteringTextInputFormatter.deny(' ')
                            ],
                            decoration: InputDecoration(
                              label: const Row(
                                children: [
                                  Spacer(),
                                  Icon(
                                    CupertinoIcons.phone_solid,
                                    color: Colors.teal,
                                  ),
                                  SizedBox(width: 5),
                                  Text('رقم الواتس'),
                                ],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '*فارغ';
                              }
                              return null;
                            },
                            controller: cubit.nameCont,
                            decoration: InputDecoration(
                              label: const Row(
                                children: [
                                  Spacer(),
                                  Icon(
                                    CupertinoIcons.person_solid,
                                    color: Colors.teal,
                                  ),
                                  SizedBox(width: 5),
                                  Text('الاسم'),
                                ],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    TextButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          cubit.addClient();
                        }
                      },
                      child: Container(
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00796B), Color(0xFF004D40)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'اضافة',
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                width: 500,
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
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
                child: ListView.separated(
                  itemCount: cubit.clientsModel!.clients!.length,
                  itemBuilder: (context, index) => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.phone_circle_fill,
                            color: Colors.teal,
                          ),
                          const SizedBox(width: 10),
                          SelectableText(
                            cubit.clientsModel!.clients![index]!.clientphone!,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            cursorColor: Colors.blue,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          SelectableText(
                            cubit.clientsModel!.clients![index]!.clientname!,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            cursorColor: Colors.blue,
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            CupertinoIcons.person_circle_fill,
                            color: Colors.teal,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      IconButton(
                        icon: const Icon(
                          CupertinoIcons.delete_solid,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: const Text('تنبيه'),
                                    content: const Text(
                                        'هل تريد ان تحذف هذا العميل؟'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('نعم'),
                                        onPressed: () {
                                          cubit.deleteClient(
                                              id: cubit.clientsModel!
                                                  .clients![index]!.id!);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('لا'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ]);
                              });
                        },
                      ),
                    ],
                  ),
                  separatorBuilder: (context, index) => const Divider(),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
