import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor for logging HTTP requests and responses
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      final method = options.method.toUpperCase();
      final url = options.uri.toString();
      final time = DateTime.now();
      
      // Log request
      print('🐙 REQUEST [$method] => URL: $url => TIME: $time');
      
      // Log headers if present
      if (options.headers.isNotEmpty) {
        print('   HEADERS: ${_formatHeaders(options.headers)}');
      }
      
      // Log request body if present
      if (options.data != null) {
        print('   BODY: ${_formatBody(options.data)}');
      }
      
      // Log query parameters if present
      if (options.queryParameters.isNotEmpty) {
        print('   QUERY: ${options.queryParameters}');
      }
      
      print(''); // Empty line for readability
    }
    
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      final method = response.requestOptions.method.toUpperCase();
      final url = response.requestOptions.uri.toString();
      final statusCode = response.statusCode;
      final time = DateTime.now();
      
      // Log response
      print('✅ RESPONSE [$method] => URL: $url => STATUS: $statusCode => TIME: $time');
      
      // Log response headers
      if (response.headers.map.isNotEmpty) {
        print('   HEADERS: ${_formatResponseHeaders(response.headers)}');
      }
      
      // Log response body
      print('   BODY: ${_formatBody(response.data)}');
      print(''); // Empty line for readability
    }
    
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      final method = err.requestOptions.method.toUpperCase();
      final url = err.requestOptions.uri.toString();
      final time = DateTime.now();
      
      // Log error
      print('❌ ERROR [$method] => URL: $url => TIME: $time');
      print('   ERROR TYPE: ${err.type}');
      print('   ERROR MESSAGE: ${err.message}');
      
      // Log error response if available
      if (err.response != null) {
        print('   STATUS CODE: ${err.response?.statusCode}');
        print('   RESPONSE: ${_formatBody(err.response?.data)}');
      }
      
      // Log stack trace in debug mode
      if (err.stackTrace != null) {
        print('   STACK TRACE: ${err.stackTrace}');
      }
      
      print(''); // Empty line for readability
    }
    
    super.onError(err, handler);
  }

  /// Format headers for logging
  String _formatHeaders(Map<String, dynamic> headers) {
    final filtered = Map<String, dynamic>.from(headers);
    
    // Hide sensitive data
    if (filtered.containsKey('authorization') || filtered.containsKey('Authorization')) {
      filtered['authorization'] = '***HIDDEN***';
      filtered['Authorization'] = '***HIDDEN***';
    }
    
    return filtered.toString();
  }

  /// Format response headers for logging
  String _formatResponseHeaders(Headers headers) {
    return headers.map.toString();
  }

  /// Format body for logging
  String _formatBody(dynamic body) {
    if (body == null) return 'null';
    
    // If body is already a string, return it
    if (body is String) {
      return body.length > 1000 ? '${body.substring(0, 1000)}... (truncated)' : body;
    }
    
    // Convert to string
    final bodyStr = body.toString();
    
    // Truncate if too long
    if (bodyStr.length > 1000) {
      return '${bodyStr.substring(0, 1000)}... (truncated)';
    }
    
    return bodyStr;
  }
}
