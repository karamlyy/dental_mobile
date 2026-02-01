import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class AppointmentsApi {
  final DioClient dioClient;
  AppointmentsApi(this.dioClient);

  Future<List<Map<String, dynamic>>> getAppointments(
    String accessToken, {
    String? date,
  }) async {
    final res = await dioClient.dio.get(
      '/appointments',
      queryParameters: date != null ? {'date': date} : null,
      options: Options(headers: {
        'Authorization': 'Bearer $accessToken',
      }),
    );
    return List<Map<String, dynamic>>.from(res.data);
  }
}