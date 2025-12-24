import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class AssistantsApi {
  final DioClient dioClient;
  AssistantsApi(this.dioClient);

  Future<List<Map<String, dynamic>>> getAssistants(String accessToken) async {
    final res = await dioClient.dio.get(
      '/assistants',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return List<Map<String, dynamic>>.from(res.data);
  }

  Future<Map<String, dynamic>> createAssistant(
    String accessToken,
    Map<String, dynamic> body,
  ) async {
    final res = await dioClient.dio.post(
      '/assistants',
      data: body,
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return res.data;
  }
}
