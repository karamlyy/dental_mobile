import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/patient_detail_api.dart';
import '../../../../core/error/error_handler.dart';

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
      final error = ErrorHandler.handle(e);
      emit(PatientPaymentsError(
        error.message,
        error: error.error,
        statusCode: error.statusCode,
      ));
    }
  }

  Future<void> createPayment(
    int patientId,
    String amount,
    String note,
    DateTime? date,
  ) async {
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final body = <String, dynamic>{
        'amount': int.parse(amount),
        'note': note,
      };

      // Add date to the request if provided
      if (date != null) {
        // Convert to UTC at noon to avoid timezone issues
        final utcDate = DateTime.utc(date.year, date.month, date.day, 12, 0, 0);
        body['date'] = utcDate.toIso8601String();
      }

      await api.createPayment(patientId, token, body);

      // Refresh list
      await fetchPayments(patientId);
    } catch (e) {
      if (isClosed) return;
      final error = ErrorHandler.handle(e);
      emit(PatientPaymentsError(
        error.message,
        error: error.error,
        statusCode: error.statusCode,
      ));
    }
  }
}
