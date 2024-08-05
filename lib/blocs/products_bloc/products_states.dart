abstract class ProductsStates {}

class ProductsInitial extends ProductsStates {}

class ProductsFailure extends ProductsStates {
  String msg = '';
  ProductsFailure({required this.msg});
}

class ProductsSuccess extends ProductsStates {}

class ProductUpdated extends ProductsStates {}

class ProductAdded extends ProductsStates {}

class ReceiptCreated extends ProductsStates {
  String msg = '';
  ReceiptCreated({required this.msg});
}
