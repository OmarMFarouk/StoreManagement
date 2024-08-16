import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/clients_model.dart';
import '../../services/clients_api.dart';
import 'Clients_states.dart';

class ClientsCubit extends Cubit<ClientsStates> {
  ClientsCubit() : super(ClientsInitial());
  static ClientsCubit get(context) => BlocProvider.of(context);

  TextEditingController nameCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();
  ClientsModel? clientsModel;
  fetchClients() async {
    emit(ClientsLoading());
    ClientsApi().fetchClients().then((value) {
      if (value['success'] == true) {
        emit(ClientsInitial());
        clientsModel = ClientsModel.fromJson(value);
      } else if (value['success'] == false) {
        emit(ClientsError(msg: value['message']));
      } else if (value == 'error') {
        emit(ClientsError(msg: 'Check Internet Connection'));
      }
    });
  }

  addClient() async {
    emit(ClientsLoading());
    Client client =
        Client(clientname: nameCont.text, clientphone: phoneCont.text);
    ClientsApi().addClient(client: client).then((value) {
      if (value['success'] == true) {
        emit(ClientsSuccess(msg: value['message']));
        fetchClients();
        clear();
      } else if (value['success'] == false) {
        emit(ClientsError(msg: value['message']));
      } else if (value == 'error') {
        emit(ClientsError(msg: 'Check Internet Connection'));
      }
    });
  }

  deleteClient({required String id}) async {
    emit(ClientsLoading());

    ClientsApi().deleteClient(clientId: id).then((value) {
      if (value['success'] == true) {
        emit(ClientsSuccess(msg: value['message']));
        fetchClients();
      } else if (value['success'] == false) {
        emit(ClientsError(msg: value['message']));
      } else if (value == 'error') {
        emit(ClientsError(msg: 'Check Internet Connection'));
      }
    });
  }

  clear() {
    nameCont.clear();
    phoneCont.clear();
  }
}
