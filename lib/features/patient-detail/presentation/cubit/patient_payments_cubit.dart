import 'package:dental_mobile/features/patients/data/patients_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/patient_detail_api.dart';

part 'patient_payments_state.dart';

class PatientPaymentsCubit extends Cubit<PatientPaymentsState> {
  final PatientDetailApi api;
  final SecureStorage storage;

  PatientPaymentsCubit(this.api, this.storage)
    : super(PatientPaymentsInitial());

  Future<void> fetchPayments(int patientId) async {
    emit(PatientPaymentsLoading());
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final payments = await api.getPayments(patientId, token);
      emit(PatientPaymentsLoaded(payments));
    } catch (e) {
      emit(PatientPaymentsError(e.toString()));
    }
  }

  Future<void> addPayment(int patientId, String amount, String note) async {
    emit(PatientPaymentsLoading());
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final newPayment = await api.createPayment(patientId, token, {
        'amount': amount,
        'note': note,
      });

      final current = (state is PatientPaymentsLoaded)
          ? (state as PatientPaymentsLoaded).payments
          : [];
      emit(PatientPaymentsLoaded([...current, newPayment]));
    } catch (e) {
      emit(PatientPaymentsError(e.toString()));
    }
  }
}
