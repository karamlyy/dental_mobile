import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class ServicesApi {
  final DioClient dioClient;

  ServicesApi(this.dioClient);

  Future<List<Map<String, dynamic>>> getServices(String accessToken) async {
    final res = await dioClient.dio.get(
      '/services',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return List<Map<String, dynamic>>.from(res.data);
  }

  Future<Map<String, dynamic>> createService(
    String accessToken,
    Map<String, dynamic> body,
  ) async {
    final res = await dioClient.dio.post(
      '/services',
      data: body,
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return res.data;
  }
}
