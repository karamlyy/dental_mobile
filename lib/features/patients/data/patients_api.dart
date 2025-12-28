import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class PatientsApi {
  final DioClient dioClient;
  PatientsApi(this.dioClient);

  Future<List<Map<String, dynamic>>> getPatients(String accessToken, {String? search}) async {
    final res = await dioClient.dio.get(
      '/patients',
      queryParameters: search != null && search.isNotEmpty ? {'search': search} : null,
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return List<Map<String, dynamic>>.from(res.data);
  }

  Future<Map<String, dynamic>> createPatient(String accessToken, Map<String, dynamic> body) async {
    final res = await dioClient.dio.post(
      '/patients',
      data: body,
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return res.data;
  }


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

}