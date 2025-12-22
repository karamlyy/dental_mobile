import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class AppointmentsApi {
  final DioClient dioClient;
  AppointmentsApi(this.dioClient);

  Future<List<Map<String, dynamic>>> getAppointments(String accessToken) async {
    final res = await dioClient.dio.get(
      '/appointments',
      options: Options(headers: {
        'Authorization': 'Bearer $accessToken',
      }),
    );
    return List<Map<String, dynamic>>.from(res.data);
  }
}