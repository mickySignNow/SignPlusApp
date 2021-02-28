import 'package:cloud_functions/cloud_functions.dart';

class FirebaseConstFunctions {
  static final _functions = FirebaseFunctions.instance;

  /// all functions must start with capital
  static HttpsCallable getRoleById = _functions.httpsCallable('CheckUserRole');
  static HttpsCallable getCustomerName =
      _functions.httpsCallable('GetCustomerNameById');
  static HttpsCallable createOrginization =
      _functions.httpsCallable('CreateOrginization');
  static HttpsCallable createEvent = _functions.httpsCallable('CreateEvent');
  static HttpsCallable bookEvent = _functions.httpsCallable('InterBookEvent');
  static HttpsCallable codeValidation =
      _functions.httpsCallable('CodeValidation');
  static HttpsCallable createCustomer =
      _functions.httpsCallable('CreateCustomer');
  static HttpsCallable createInter = _functions.httpsCallable('CreateInter');
  static HttpsCallable getEvents = _functions.httpsCallable('GetAllEvents');
  static HttpsCallable getAllCustomers =
      _functions.httpsCallable('GetAllCustomers');
  static HttpsCallable getAllInters = _functions.httpsCallable('GetAllInters');
  static HttpsCallable getAllOrginizations =
      _functions.httpsCallable('GetAllOrginizations');
  static HttpsCallable deleteUser = _functions.httpsCallable('DeleteUserById');
  static HttpsCallable getAllUnOccupiedEvents =
      _functions.httpsCallable('GetAllNotOccupiedEvents');
  static HttpsCallable getAllOccupiedEvents =
      _functions.httpsCallable('GetAllOccupiedEvents');
  static HttpsCallable gethistoryEvents =
      _functions.httpsCallable('GetHistoryEvents');
  static HttpsCallable createCustomerEmailPhone =
      _functions.httpsCallable('CreateCustomerTest');
  static HttpsCallable createInterEmailPhone =
      _functions.httpsCallable('CreateInterTest');
  static HttpsCallable getAllEvents =
      _functions.httpsCallable('GetAllEventsWithHistories');
}
