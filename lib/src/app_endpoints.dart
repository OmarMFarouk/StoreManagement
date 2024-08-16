class AppEndPoints {
  static const String endPoint = 'https://komiwall.com/store/public';
  // authentication
  static const String loginUser = '$endPoint/auth/login.php';
  // products
  static const String showProducts = '$endPoint/products/show_products.php';
  static const String addProduct = '$endPoint/products/add_product.php';
  static const String updateProduct = '$endPoint/products/update_product.php';
  static const String deleteProduct = '$endPoint/products/delete_product.php';

  // receipts & returns
  static const String createReceipt = '$endPoint/receipts/create_receipt.php';
  static const String createReturn = '$endPoint/receipts/create_return.php';
  static const String showReceipts = '$endPoint/receipts/show_receipts.php';
  static const String showReturns = '$endPoint/receipts/show_returns.php';

  // employees
  static const String createEmployee =
      '$endPoint/employees/create_employee.php';
  static const String showEmployees = '$endPoint/employees/show_employees.php';
  static const String deleteEmployee =
      '$endPoint/employees/delete_employee.php';
  static const String employeeData =
      '$endPoint/employees/show_employee_data.php';

  // clients
  static const String showClients = '$endPoint/clients/show_clients.php';
  static const String addClient = '$endPoint/clients/add_client.php';
  static const String deleteClient = '$endPoint/clients/delete_client.php';

  // treasury
  static const String treasuryWithdraw =
      '$endPoint/treasury/treasury_withdraw.php';
  static const String showTreasury = '$endPoint/treasury/show_treasury.php';
}
