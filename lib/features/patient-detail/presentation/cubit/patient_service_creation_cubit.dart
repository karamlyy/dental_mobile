import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/patient_detail_api.dart';
import 'patient_service_creation_state.dart';

class PatientServiceCreationCubit extends Cubit<PatientServiceCreationState> {
  final PatientDetailApi api;
  final SecureStorage storage;

  PatientServiceCreationCubit(this.api, this.storage)
      : super(PatientServiceCreationInitial());

  Future<void> createService({
    required int patientId,
    required String name,
    required double price,
  }) async {
    emit(PatientServiceCreationLoading());
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      await api.createService(patientId, token, {
        'name': name,
        'price': price,
      });

      emit(PatientServiceCreationSuccess());
    } catch (e) {
      emit(PatientServiceCreationError(e.toString()));
    }
  }
}
