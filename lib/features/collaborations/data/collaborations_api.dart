import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class CollaborationsApi {
  final DioClient dioClient;

  CollaborationsApi(this.dioClient);

  Future<List<Map<String, dynamic>>> getCollaborations(String accessToken) async {
    final res = await dioClient.dio.get(
      '/collaborations',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return List<Map<String, dynamic>>.from(res.data);
  }

  Future<Map<String, dynamic>> createCollaboration(
    String accessToken,
    Map<String, dynamic> body,
  ) async {
    final res = await dioClient.dio.post(
      '/collaborations',
      data: body,
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return res.data;
  }

  Future<Map<String, dynamic>> updateCollaboration(
    String accessToken,
    String collaborationId,
    Map<String, dynamic> body,
  ) async {
    final res = await dioClient.dio.patch(
      '/collaborations/$collaborationId',
      data: body,
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return res.data;
  }

  Future<void> deleteCollaboration(
    String accessToken,
    String collaborationId,
  ) async {
    await dioClient.dio.delete(
      '/collaborations/$collaborationId',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
  }
}
