import 'package:dio/dio.dart';
import '../../config/flavor_config.dart';

class DioClient {
  final Dio dio;
  DioClient(this.dio) {
    // Use flavor-specific base URL
    dio.options.baseUrl = FlavorConfig.instance.apiBaseUrl;
    dio.options.headers = {
      'Content-Type': 'application/json',
      'accept': '*/*',
    };
  }

  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? headers}) async {
    return dio.post(path, data: data, options: Options(headers: headers));
  }
}