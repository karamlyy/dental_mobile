import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../services/data/services_api.dart';
import 'patient_services_state.dart';

class PatientServicesCubit extends Cubit<PatientServicesState> {
  final ServicesApi api;
  final SecureStorage storage;

  PatientServicesCubit(this.api, this.storage)
      : super(PatientServicesInitial());

  Future<void> fetchServices(int patientId) async {
    try {
      emit(PatientServicesLoading());
      final token = await storage.read('accessToken');
      if (token == null) {
        emit(PatientServicesError('Unauthorized'));
        return;
      }

      final services = await api.getPatientServices(token, patientId);
      emit(PatientServicesLoaded(services));
    } catch (e) {
      emit(PatientServicesError(e.toString()));
    }
  }

  Future<void> updateService({
    required int patientId,
    required int serviceId,
    required String name,
    required double price,
  }) async {
    try {
      emit(PatientServicesLoading());
      final token = await storage.read('accessToken');
      if (token == null) {
        emit(PatientServicesError('Unauthorized'));
        return;
      }

      await api.updatePatientService(token, patientId, serviceId, {
        'name': name,
        'price': price,
      });
      
      // Refresh the list after update
      await fetchServices(patientId);
    } catch (e) {
      emit(PatientServicesError(e.toString()));
    }
  }
}
