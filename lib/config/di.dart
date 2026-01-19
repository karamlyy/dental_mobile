import 'package:dental_mobile/config/theme/theme_cubit.dart';
import 'package:dental_mobile/core/analytics/analytics_service.dart';
import 'package:dental_mobile/core/cache/cache_service.dart';
import 'package:dental_mobile/core/localization/locale_cubit.dart';
import 'package:dental_mobile/features/assistants/data/assistants_api.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:dental_mobile/features/assistants/presentation/cubit/assistants_cubit.dart';
import 'package:dental_mobile/features/assistants/presentation/cubit/assistant_creation_cubit.dart';
import 'package:dental_mobile/features/patient-detail/presentation/cubit/patient_services_cubit.dart';
import 'package:dental_mobile/features/services/data/services_api.dart';
import 'package:dental_mobile/features/services/presentation/cubit/services_cubit.dart';
import 'package:dental_mobile/features/services/presentation/cubit/service_creation_cubit.dart';
import 'package:dental_mobile/features/home/data/stats_api.dart';
import 'package:dental_mobile/features/home/presentation/cubit/stats_cubit.dart';
import 'package:dental_mobile/features/patient-detail/presentation/cubit/patient_appointments_cubit.dart';
import 'package:dental_mobile/features/patient-detail/presentation/cubit/patient_detail_cubit.dart';
import 'package:dental_mobile/features/patient-detail/presentation/cubit/patient_payments_cubit.dart';
import 'package:dental_mobile/features/patient-detail/presentation/cubit/patient_appointment_creation_cubit.dart';
import 'package:dental_mobile/features/patient-detail/presentation/cubit/patient_service_creation_cubit.dart';
import 'package:dental_mobile/features/patient-detail/presentation/cubit/appointment_schedule_cubit.dart';
import 'package:dental_mobile/features/patient-detail/presentation/cubit/patient_notes_cubit.dart';
import 'package:dental_mobile/features/patient-detail/presentation/cubit/patient_note_creation_cubit.dart';
import 'package:dental_mobile/features/patients/data/patients_api.dart';
import 'package:dental_mobile/features/patients/presentation/cubit/patients_cubit.dart';
import 'package:dental_mobile/features/patients/presentation/cubit/add_patient_cubit.dart';
import 'package:dental_mobile/features/collaborations/data/collaborations_api.dart';
import 'package:dental_mobile/features/collaborations/presentation/cubit/collaborations_cubit.dart';
import 'package:dental_mobile/features/collaborations/presentation/cubit/collaboration_creation_cubit.dart';
import 'package:dental_mobile/features/expenses/data/expenses_api.dart';
import 'package:dental_mobile/features/expenses/presentation/cubit/expenses_cubit.dart';
import 'package:dental_mobile/features/expenses/presentation/cubit/expense_creation_cubit.dart';
import 'package:dental_mobile/features/profile/data/profile_api.dart';
import 'package:dental_mobile/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:dental_mobile/features/profile/presentation/cubit/profile_update_cubit.dart';
import 'package:dental_mobile/features/profile/presentation/cubit/profile_form_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../core/network/auth_interceptor.dart';
import '../core/network/logging_interceptor.dart';
import '../core/network/dio_client.dart';
import '../core/storage/secure_storage.dart';
import '../features/auth/data/auth_api.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/home/data/appointments_api.dart';
import '../features/home/presentation/cubit/appointments_cubit.dart';
import '../features/appointments/presentation/cubit/appointments_page_cubit.dart';
import '../features/patient-detail/data/patient_detail_api.dart';

final sl = GetIt.instance;

Future<void> init({required CacheService cacheService}) async {
  // Cache Service (initialized externally and passed in)
  sl.registerLazySingleton<CacheService>(() => cacheService);

  // Analytics
  sl.registerLazySingleton<FirebaseAnalytics>(() => FirebaseAnalytics.instance);
  sl.registerLazySingleton<AnalyticsService>(() => AnalyticsService(sl<FirebaseAnalytics>()));

  sl.registerLazySingleton<SecureStorage>(() => SecureStorage());
  sl.registerLazySingleton<DioClient>(() {
    final dio = Dio();
    // Add logging interceptor first to log all requests/responses
    dio.interceptors.add(LoggingInterceptor());
    // Add auth interceptor for authentication handling
    dio.interceptors.add(AuthInterceptor(sl<SecureStorage>(), sl<CacheService>()));
    return DioClient(dio);
  });

  // Theme
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit(sl<SecureStorage>(), sl<AnalyticsService>()));

  // Localization
  sl.registerLazySingleton<LocaleCubit>(() => LocaleCubit(sl<SecureStorage>(), sl<AnalyticsService>()));

  sl.registerLazySingleton<AuthApi>(() => AuthApi(sl<DioClient>()));
  sl.registerFactory(() => AuthCubit(sl<AuthApi>(), sl<SecureStorage>(), sl<AnalyticsService>(), sl<CacheService>()));

  sl.registerLazySingleton<AppointmentsApi>(
    () => AppointmentsApi(sl<DioClient>()),
  );
  sl.registerFactory(
    () => AppointmentsCubit(sl<AppointmentsApi>(), sl<SecureStorage>()),
  );
  
  sl.registerFactory(
    () => AppointmentsPageCubit(sl<AppointmentsApi>(), sl<SecureStorage>()),
  );

  sl.registerLazySingleton<PatientsApi>(() => PatientsApi(sl<DioClient>()));
  sl.registerFactory(
    () => PatientsCubit(sl<PatientsApi>(), sl<SecureStorage>()),
  );
  sl.registerFactory(
    () => AddPatientCubit(sl<PatientsApi>(), sl<SecureStorage>(), sl<AnalyticsService>()),
  );

  sl.registerLazySingleton<PatientDetailApi>(() => PatientDetailApi(sl<DioClient>()));

  sl.registerFactory(
    () => PatientDetailCubit(sl<PatientDetailApi>(), sl<SecureStorage>()),
  );
  sl.registerFactory(
    () => PatientAppointmentsCubit(sl<PatientDetailApi>(), sl<SecureStorage>()),
  );
  sl.registerFactory(
    () => PatientPaymentsCubit(sl<PatientDetailApi>(), sl<SecureStorage>()),
  );
  sl.registerFactory(
    () => PatientServicesCubit(sl<ServicesApi>(), sl<SecureStorage>()),
  );
  sl.registerFactory(
    () => PatientAppointmentCreationCubit(sl<PatientDetailApi>(), sl<SecureStorage>()),
  );
  sl.registerFactory(
    () => PatientServiceCreationCubit(sl<PatientDetailApi>(), sl<SecureStorage>()),
  );
  sl.registerFactory(
    () => AppointmentScheduleCubit(sl<PatientDetailApi>(), sl<SecureStorage>()),
  );
  sl.registerFactory(
    () => PatientNotesCubit(sl<PatientDetailApi>(), sl<SecureStorage>()),
  );
  sl.registerFactory(
    () => PatientNoteCreationCubit(sl<PatientDetailApi>(), sl<SecureStorage>()),
  );

  sl.registerLazySingleton<StatsApi>(() => StatsApi(sl<DioClient>()));
  sl.registerFactory(() => StatsCubit(sl<StatsApi>(), sl<SecureStorage>()));

  sl.registerLazySingleton<AssistantsApi>(() => AssistantsApi(sl<DioClient>()));
  sl.registerFactory(
    () => AssistantsCubit(sl<AssistantsApi>(), sl<SecureStorage>()),
  );
  sl.registerFactory(
    () => AssistantCreationCubit(sl<AssistantsApi>(), sl<SecureStorage>(), sl<AnalyticsService>()),
  );

  sl.registerLazySingleton<ServicesApi>(() => ServicesApi(sl<DioClient>()));
  sl.registerFactory(
    () => ServicesCubit(sl<ServicesApi>(), sl<SecureStorage>()),
  );
  sl.registerFactory(
    () => ServiceCreationCubit(sl<ServicesApi>(), sl<SecureStorage>(), sl<AnalyticsService>()),
  );

  sl.registerLazySingleton<CollaborationsApi>(() => CollaborationsApi(sl<DioClient>()));
  sl.registerFactory(
    () => CollaborationsCubit(sl<CollaborationsApi>(), sl<SecureStorage>()),
  );
  sl.registerFactory(
    () => CollaborationCreationCubit(sl<CollaborationsApi>(), sl<SecureStorage>(), sl<AnalyticsService>()),
  );

  sl.registerLazySingleton<ExpensesApi>(() => ExpensesApi(sl<DioClient>()));
  sl.registerFactory(
    () => ExpensesCubit(sl<ExpensesApi>(), sl<SecureStorage>()),
  );
  sl.registerFactory(
    () => ExpenseCreationCubit(sl<ExpensesApi>(), sl<SecureStorage>(), sl<AnalyticsService>()),
  );

  sl.registerLazySingleton<ProfileApi>(() => ProfileApi(sl<DioClient>()));
  sl.registerFactory(
    () => ProfileCubit(sl<ProfileApi>(), sl<SecureStorage>()),
  );
  sl.registerFactory(
    () => ProfileUpdateCubit(sl<ProfileApi>(), sl<SecureStorage>()),
  );
  sl.registerFactory(
    () => ProfileFormCubit(),
  );
}
