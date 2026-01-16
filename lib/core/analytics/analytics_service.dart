import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Centralized service for Firebase Analytics
/// Tracks all important user actions and events
class AnalyticsService {
  final FirebaseAnalytics _analytics;
  late final FirebaseAnalyticsObserver observer;

  AnalyticsService(this._analytics) {
    observer = FirebaseAnalyticsObserver(analytics: _analytics);
  }

  // ==================== User Properties ====================
  
  Future<void> setUserId(String? userId) async {
    try {
      await _analytics.setUserId(id: userId);
      if (kDebugMode) print('Analytics: User ID set: $userId');
    } catch (e) {
      if (kDebugMode) print('Analytics error setting user ID: $e');
    }
  }

  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
      if (kDebugMode) print('Analytics: User property set: $name = $value');
    } catch (e) {
      if (kDebugMode) print('Analytics error setting user property: $e');
    }
  }

  // ==================== Screen Tracking ====================
  
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
      if (kDebugMode) print('Analytics: Screen view: $screenName');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging screen view: $e');
    }
  }

  // ==================== Authentication Events ====================
  
  Future<void> logLogin(String method) async {
    try {
      await _analytics.logLogin(loginMethod: method);
      if (kDebugMode) print('Analytics: Login with $method');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging login: $e');
    }
  }

  Future<void> logSignUp(String method) async {
    try {
      await _analytics.logSignUp(signUpMethod: method);
      if (kDebugMode) print('Analytics: Sign up with $method');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging sign up: $e');
    }
  }

  Future<void> logLogout() async {
    try {
      await _analytics.logEvent(name: 'logout');
      if (kDebugMode) print('Analytics: Logout');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging logout: $e');
    }
  }

  // ==================== Patient Events ====================
  
  Future<void> logPatientCreated({int? patientId}) async {
    try {
      await _analytics.logEvent(
        name: 'patient_created',
        parameters: patientId != null ? {'patient_id': patientId} : null,
      );
      if (kDebugMode) print('Analytics: Patient created: $patientId');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging patient creation: $e');
    }
  }

  Future<void> logPatientViewed(int patientId) async {
    try {
      await _analytics.logEvent(
        name: 'patient_viewed',
        parameters: {'patient_id': patientId},
      );
      if (kDebugMode) print('Analytics: Patient viewed: $patientId');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging patient view: $e');
    }
  }

  Future<void> logPatientUpdated(int patientId) async {
    try {
      await _analytics.logEvent(
        name: 'patient_updated',
        parameters: {'patient_id': patientId},
      );
      if (kDebugMode) print('Analytics: Patient updated: $patientId');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging patient update: $e');
    }
  }

  Future<void> logPatientDeleted(int patientId) async {
    try {
      await _analytics.logEvent(
        name: 'patient_deleted',
        parameters: {'patient_id': patientId},
      );
      if (kDebugMode) print('Analytics: Patient deleted: $patientId');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging patient deletion: $e');
    }
  }

  // ==================== Appointment Events ====================
  
  Future<void> logAppointmentCreated({
    int? appointmentId,
    int? patientId,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'appointment_created',
        parameters: {
          if (appointmentId != null) 'appointment_id': appointmentId,
          if (patientId != null) 'patient_id': patientId,
        },
      );
      if (kDebugMode) print('Analytics: Appointment created: $appointmentId');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging appointment creation: $e');
    }
  }

  Future<void> logAppointmentUpdated(int appointmentId) async {
    try {
      await _analytics.logEvent(
        name: 'appointment_updated',
        parameters: {'appointment_id': appointmentId},
      );
      if (kDebugMode) print('Analytics: Appointment updated: $appointmentId');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging appointment update: $e');
    }
  }

  Future<void> logAppointmentDeleted(int appointmentId) async {
    try {
      await _analytics.logEvent(
        name: 'appointment_deleted',
        parameters: {'appointment_id': appointmentId},
      );
      if (kDebugMode) print('Analytics: Appointment deleted: $appointmentId');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging appointment deletion: $e');
    }
  }

  Future<void> logAppointmentCompleted(int appointmentId) async {
    try {
      await _analytics.logEvent(
        name: 'appointment_completed',
        parameters: {'appointment_id': appointmentId},
      );
      if (kDebugMode) print('Analytics: Appointment completed: $appointmentId');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging appointment completion: $e');
    }
  }

  // ==================== Treatment Events ====================
  
  Future<void> logTreatmentCreated({
    int? treatmentId,
    int? patientId,
    String? treatmentType,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'treatment_created',
        parameters: {
          if (treatmentId != null) 'treatment_id': treatmentId,
          if (patientId != null) 'patient_id': patientId,
          if (treatmentType != null) 'treatment_type': treatmentType,
        },
      );
      if (kDebugMode) print('Analytics: Treatment created: $treatmentId');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging treatment creation: $e');
    }
  }

  Future<void> logTreatmentUpdated(int treatmentId) async {
    try {
      await _analytics.logEvent(
        name: 'treatment_updated',
        parameters: {'treatment_id': treatmentId},
      );
      if (kDebugMode) print('Analytics: Treatment updated: $treatmentId');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging treatment update: $e');
    }
  }

  // ==================== Service Events ====================
  
  Future<void> logServiceCreated({int? serviceId, String? serviceName}) async {
    try {
      await _analytics.logEvent(
        name: 'service_created',
        parameters: {
          if (serviceId != null) 'service_id': serviceId,
          if (serviceName != null) 'service_name': serviceName,
        },
      );
      if (kDebugMode) print('Analytics: Service created: $serviceName');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging service creation: $e');
    }
  }

  Future<void> logServiceUpdated(int serviceId) async {
    try {
      await _analytics.logEvent(
        name: 'service_updated',
        parameters: {'service_id': serviceId},
      );
      if (kDebugMode) print('Analytics: Service updated: $serviceId');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging service update: $e');
    }
  }

  Future<void> logServiceDeleted(int serviceId) async {
    try {
      await _analytics.logEvent(
        name: 'service_deleted',
        parameters: {'service_id': serviceId},
      );
      if (kDebugMode) print('Analytics: Service deleted: $serviceId');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging service deletion: $e');
    }
  }

  // ==================== Expense Events ====================
  
  Future<void> logExpenseCreated({
    int? expenseId,
    double? amount,
    String? category,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'expense_created',
        parameters: {
          if (expenseId != null) 'expense_id': expenseId,
          if (amount != null) 'amount': amount,
          if (category != null) 'category': category,
        },
      );
      if (kDebugMode) print('Analytics: Expense created: $expenseId');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging expense creation: $e');
    }
  }

  Future<void> logExpenseUpdated(int expenseId) async {
    try {
      await _analytics.logEvent(
        name: 'expense_updated',
        parameters: {'expense_id': expenseId},
      );
      if (kDebugMode) print('Analytics: Expense updated: $expenseId');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging expense update: $e');
    }
  }

  Future<void> logExpenseDeleted(int expenseId) async {
    try {
      await _analytics.logEvent(
        name: 'expense_deleted',
        parameters: {'expense_id': expenseId},
      );
      if (kDebugMode) print('Analytics: Expense deleted: $expenseId');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging expense deletion: $e');
    }
  }

  // ==================== Assistant Events ====================
  
  Future<void> logAssistantCreated({int? assistantId, String? name}) async {
    try {
      await _analytics.logEvent(
        name: 'assistant_created',
        parameters: {
          if (assistantId != null) 'assistant_id': assistantId,
          if (name != null) 'name': name,
        },
      );
      if (kDebugMode) print('Analytics: Assistant created: $name');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging assistant creation: $e');
    }
  }

  Future<void> logAssistantUpdated(int assistantId) async {
    try {
      await _analytics.logEvent(
        name: 'assistant_updated',
        parameters: {'assistant_id': assistantId},
      );
      if (kDebugMode) print('Analytics: Assistant updated: $assistantId');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging assistant update: $e');
    }
  }

  Future<void> logAssistantDeleted(int assistantId) async {
    try {
      await _analytics.logEvent(
        name: 'assistant_deleted',
        parameters: {'assistant_id': assistantId},
      );
      if (kDebugMode) print('Analytics: Assistant deleted: $assistantId');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging assistant deletion: $e');
    }
  }

  // ==================== Collaboration Events ====================
  
  Future<void> logCollaborationCreated({
    int? collaborationId,
    String? type,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'collaboration_created',
        parameters: {
          if (collaborationId != null) 'collaboration_id': collaborationId,
          if (type != null) 'type': type,
        },
      );
      if (kDebugMode) print('Analytics: Collaboration created: $collaborationId');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging collaboration creation: $e');
    }
  }

  // ==================== Profile Events ====================
  
  Future<void> logProfileViewed() async {
    try {
      await _analytics.logEvent(name: 'profile_viewed');
      if (kDebugMode) print('Analytics: Profile viewed');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging profile view: $e');
    }
  }

  Future<void> logProfileUpdated() async {
    try {
      await _analytics.logEvent(name: 'profile_updated');
      if (kDebugMode) print('Analytics: Profile updated');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging profile update: $e');
    }
  }

  // ==================== Settings Events ====================
  
  Future<void> logThemeChanged(String theme) async {
    try {
      await _analytics.logEvent(
        name: 'theme_changed',
        parameters: {'theme': theme},
      );
      if (kDebugMode) print('Analytics: Theme changed to $theme');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging theme change: $e');
    }
  }

  Future<void> logLanguageChanged(String language) async {
    try {
      await _analytics.logEvent(
        name: 'language_changed',
        parameters: {'language': language},
      );
      if (kDebugMode) print('Analytics: Language changed to $language');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging language change: $e');
    }
  }

  // ==================== Search Events ====================
  
  Future<void> logSearch({
    required String searchTerm,
    String? category,
  }) async {
    try {
      await _analytics.logSearch(
        searchTerm: searchTerm,
        numberOfNights: null,
        numberOfRooms: null,
        numberOfPassengers: null,
        origin: null,
        destination: null,
        startDate: null,
        endDate: null,
        travelClass: null,
      );
      if (kDebugMode) print('Analytics: Search: $searchTerm');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging search: $e');
    }
  }

  // ==================== Error Events ====================
  
  Future<void> logError({
    required String errorMessage,
    String? errorCode,
    String? screen,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'error_occurred',
        parameters: {
          'error_message': errorMessage,
          if (errorCode != null) 'error_code': errorCode,
          if (screen != null) 'screen': screen,
        },
      );
      if (kDebugMode) print('Analytics: Error: $errorMessage');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging error: $e');
    }
  }

  // ==================== Custom Events ====================
  
  Future<void> logCustomEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await _analytics.logEvent(
        name: eventName,
        parameters: parameters?.map((key, value) => MapEntry(key, value as Object)),
      );
      if (kDebugMode) print('Analytics: Custom event: $eventName');
    } catch (e) {
      if (kDebugMode) print('Analytics error logging custom event: $e');
    }
  }
}
