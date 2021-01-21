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
}
