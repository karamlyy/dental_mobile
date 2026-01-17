import 'package:dio/dio.dart';
import 'package:dental_mobile/core/constants.dart';

class DioClient {
  final Dio dio;
  DioClient(this.dio) {
    // Use base URL from constants
    dio.options.baseUrl = AppConstants.baseUrl;
    dio.options.headers = {
      'Content-Type': 'application/json',
      'accept': '*/*',
    };
  }

  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? headers}) async {
    return dio.post(path, data: data, options: Options(headers: headers));
  }
}