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
  static HttpsCallable updateEvent = _functions.httpsCallable('updateEvent');
  static HttpsCallable getInterName =
      _functions.httpsCallable("GetInterNameById");
  static HttpsCallable createODMCustomer =
      _functions.httpsCallable('CreateCustomerOnDemand');
  static HttpsCallable createCustomerRating =
      _functions.httpsCallable('CreateCustomerRating');
  static HttpsCallable createODMEvent =
      _functions.httpsCallable('CreateOnDemandEvent');
  static HttpsCallable deleteEvent =
      _functions.httpsCallable('DeleteEventById');
  static HttpsCallable deletePastEvents =
      _functions.httpsCallable('DeletePastEvent');
  static HttpsCallable getAllCustomers =
      _functions.httpsCallable('GetAllCustomers');
  static HttpsCallable getAllOccupiedEventsById =
      _functions.httpsCallable('GetAllEventsOccupiedByCustomerId');
  static HttpsCallable getAllNotOccupiedEventsById =
      _functions.httpsCallable('GetAllEventsNotOccupiedByCustomerId');
  static HttpsCallable getAllInters = _functions.httpsCallable('GetAllInters');
  static HttpsCallable getAllOccupiedEvents =
      _functions.httpsCallable('GetAllEventsOccupied');
  static HttpsCallable getAllNotOccupiedEvents =
      _functions.httpsCallable('GetAllEventsNotOccupied');
  static HttpsCallable getEventById = _functions.httpsCallable('GetEventById');
  static HttpsCallable getHistoryEvents =
      _functions.httpsCallable('GetHistoryEventByUserId');
  static HttpsCallable getPasswordByEmail =
      _functions.httpsCallable('GetPasswordByEmail');
  static HttpsCallable getPasswordByPhone =
      _functions.httpsCallable('GetPasswordByPhone');
  static HttpsCallable resetPasswordViaMailLink =
      _functions.httpsCallable('ResetPasswordLink');
  static HttpsCallable updatePassword =
      _functions.httpsCallable('UpdatePassword');
  static HttpsCallable sendEmailVerification =
      _functions.httpsCallable('SendEmailVerification');
  static HttpsCallable updateLastLogin =
      _functions.httpsCallable('UpdateLastLogin');
  static HttpsCallable interBookEventOnDemand =
      _functions.httpsCallable('InterBookEventOnDemand');
  static HttpsCallable getAuthenticatedUser =
      _functions.httpsCallable('GetAuthenticatedUser');
  static HttpsCallable getOrginizationAbilty =
      _functions.httpsCallable('CheckOrginizationAbility');
  static HttpsCallable deleteODM =
      _functions.httpsCallable('DeleteODEventByCustomerId');
}
