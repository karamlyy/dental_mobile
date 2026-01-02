import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class PatientDetailApi {
  final DioClient dioClient;
  PatientDetailApi(this.dioClient);


  Future<Map<String, dynamic>> getPatientById(
      String accessToken,
      int id,
      ) async {
    final res = await dioClient.dio.get(
      '/patients/$id',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return res.data;
  }


  Future<List<Map<String, dynamic>>> getPatientAppointments(
      String accessToken,
      int patientId,
      ) async {
    final res = await dioClient.dio.get(
      '/patients/$patientId/appointments',
      options: Options(
        headers: {'Authorization': 'Bearer $accessToken'},
      ),
    );

    return List<Map<String, dynamic>>.from(res.data);
  }


  Future<Map<String, dynamic>> updateAppointmentStatus(
      int appointmentId, String token, Map<String, dynamic> body) async {
    final res = await dioClient.dio.patch(
      '/appointments/$appointmentId',
      data: body,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data;
  }



  Future<List<Map<String, dynamic>>> getPayments(int patientId, String token) async {
    final res = await dioClient.dio.get(
      '/patients/$patientId/payments',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return List<Map<String, dynamic>>.from(res.data);
  }

  Future<Map<String, dynamic>> createPayment(int patientId, String token, Map<String, dynamic> body) async {
    final res = await dioClient.dio.post(
      '/patients/$patientId/payments',
      data: body,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return res.data;
  }

  Future<void> createAppointment(
      int patientId, String token, Map<String, dynamic> body) async {
    await dioClient.dio.post(
      '/patients/$patientId/appointments',
      data: body,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  Future<List<Map<String, dynamic>>> getSchedule(
      String token, String date) async {
    final res = await dioClient.dio.get(
      '/appointments/schedule',
      queryParameters: {'date': date},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return List<Map<String, dynamic>>.from(res.data);
  }
  Future<void> createService(
      int patientId, String token, Map<String, dynamic> body) async {
    await dioClient.dio.post(
      '/patients/$patientId/services',
      data: body,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}