// features/home/data/stats_api.dart
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class StatsApi {
  final DioClient dioClient;
  StatsApi(this.dioClient);

  Future<Map<String, dynamic>> getHomeStats(String token) async {
    final res = await dioClient.dio.get(
      '/stats/home',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    return Map<String, dynamic>.from(res.data);
  }
}