import 'package:dental_mobile/config/theme/theme_cubit.dart';
import 'package:dental_mobile/features/assistants/data/assistants_api.dart';
import 'package:dental_mobile/features/assistants/presentation/cubit/assistants_cubit.dart';
import 'package:dental_mobile/features/home/data/stats_api.dart';
import 'package:dental_mobile/features/home/presentation/cubit/stats_cubit.dart';
import 'package:dental_mobile/features/patient-detail/presentation/cubit/patient_appointments_cubit.dart';
import 'package:dental_mobile/features/patient-detail/presentation/cubit/patient_detail_cubit.dart';
import 'package:dental_mobile/features/patient-detail/presentation/cubit/patient_payments_cubit.dart';
import 'package:dental_mobile/features/patients/data/patients_api.dart';
import 'package:dental_mobile/features/patients/presentation/cubit/patients_cubit.dart';
import 'package:dental_mobile/features/patients/presentation/cubit/add_patient_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';
import '../core/storage/secure_storage.dart';
import '../features/auth/data/auth_api.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/home/data/appointments_api.dart';
import '../features/home/presentation/cubit/appointments_cubit.dart';
import '../features/patient-detail/data/patient_detail_api.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<DioClient>(() => DioClient(Dio()));
  sl.registerLazySingleton<SecureStorage>(() => SecureStorage());

  // Theme
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit(sl<SecureStorage>()));

  sl.registerLazySingleton<AuthApi>(() => AuthApi(sl<DioClient>()));
  sl.registerFactory(() => AuthCubit(sl<AuthApi>(), sl<SecureStorage>()));

  sl.registerLazySingleton<AppointmentsApi>(
    () => AppointmentsApi(sl<DioClient>()),
  );
  sl.registerFactory(
    () => AppointmentsCubit(sl<AppointmentsApi>(), sl<SecureStorage>()),
  );

  sl.registerLazySingleton<PatientsApi>(() => PatientsApi(sl<DioClient>()));
  sl.registerFactory(
    () => PatientsCubit(sl<PatientsApi>(), sl<SecureStorage>()),
  );
  sl.registerFactory(
    () => AddPatientCubit(sl<PatientsApi>(), sl<SecureStorage>()),
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

  sl.registerLazySingleton<StatsApi>(() => StatsApi(sl<DioClient>()));
  sl.registerFactory(() => StatsCubit(sl<StatsApi>(), sl<SecureStorage>()));

  sl.registerLazySingleton<AssistantsApi>(() => AssistantsApi(sl<DioClient>()));
  sl.registerFactory(
    () => AssistantsCubit(sl<AssistantsApi>(), sl<SecureStorage>()),
  );
}
