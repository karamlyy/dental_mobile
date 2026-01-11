import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';

class ProfileApi {
  final DioClient dioClient;
  ProfileApi(this.dioClient);

  Future<Map<String, dynamic>> getProfile(String accessToken) async {
    final res = await dioClient.dio.get(
      '/users/profile',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return res.data;
  }
}
