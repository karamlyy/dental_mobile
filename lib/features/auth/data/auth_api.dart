import 'package:dental_mobile/core/network/dio_client.dart';

class AuthApi {
  final DioClient dioClient;
  AuthApi(this.dioClient);

  Future<Map<String, dynamic>> register(Map<String, dynamic> body) async {
    final res = await dioClient.post('/auth/register', data: body);
    return res.data;
  }

  Future<Map<String, dynamic>> login(Map<String, dynamic> body) async {
    final res = await dioClient.post('/auth/login', data: body);
    return res.data;
  }
}
