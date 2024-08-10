class AppEndPoints {
  static const String endPoint = 'https://komiwall.com/store/public';
  // authentication
  static const String loginUser = '$endPoint/auth/login.php';
  // products
  static const String showProducts = '$endPoint/products/show_products.php';
  static const String addProduct = '$endPoint/products/add_product.php';
  static const String updateProduct = '$endPoint/products/update_product.php';

  // receipts & returns
  static const String createReceipt = '$endPoint/receipts/create_receipt.php';
  static const String createReturn = '$endPoint/receipts/create_return.php';
  static const String showReceipts = '$endPoint/receipts/show_receipts.php';

  // employees
  static const String createEmployee =
      '$endPoint/employees/create_employee.php';
  static const String showEmployees = '$endPoint/employees/show_employees.php';
  static const String employeeData =
      '$endPoint/employees/show_employee_data.php';
}
