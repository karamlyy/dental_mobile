import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/patients_api.dart';
import '../../../../core/error/error_handler.dart';

part 'add_patient_state.dart';

class AddPatientCubit extends Cubit<AddPatientState> {
  final PatientsApi api;
  final SecureStorage storage;
  final AnalyticsService analytics;

  AddPatientCubit(this.api, this.storage, this.analytics) : super(const AddPatientState());

  void fullNameChanged(String value) {
    emit(state.copyWith(fullName: value));
  }

  void phoneChanged(String value) {
    emit(state.copyWith(phone: value));
  }

  void genderChanged(String value) {
    emit(state.copyWith(gender: value));
  }

  Future<void> submit() async {
    if (state.fullName.isEmpty || state.phone.isEmpty) {
      emit(state.copyWith(
        status: AddPatientStatus.error,
        errorMessage: 'Bütün xanaları doldurun',
      ));
      return;
    }

    emit(state.copyWith(status: AddPatientStatus.loading));

    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final result = await api.createPatient(token, {
        'fullName': state.fullName,
        'phone': state.phone,
        'gender': state.gender,
      });

      // Track patient creation in Analytics
      final patientId = result['id'] as int?;
      await analytics.logPatientCreated(patientId: patientId);

      if (isClosed) return;
      emit(state.copyWith(status: AddPatientStatus.success));
    } catch (e) {
      if (isClosed) return;
      final error = ErrorHandler.handle(e);
      emit(state.copyWith(
        status: AddPatientStatus.error,
        errorMessage: error.message,
        error: error.error,
        statusCode: error.statusCode,
      ));
    }
  }
}
