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
      if (isClosed) return;
      emit(PatientPaymentsLoaded(payments));
    } catch (e) {
      if (isClosed) return;
      emit(PatientPaymentsError(e.toString()));
    }
  }

  Future<void> createPayment(int patientId, String amount, String note) async {
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      await api.createPayment(patientId, token, {
        'amount': int.parse(amount),
        'note': note,
      });

      // Refresh list
      await fetchPayments(patientId);
    } catch (e) {
      if (isClosed) return;
      emit(PatientPaymentsError(e.toString()));
    }
  }
}
