class AppError {
  final String message;
  final String? error;
  final int? statusCode;

  AppError({
    required this.message,
    this.error,
    this.statusCode,
  });

  factory AppError.fromJson(Map<String, dynamic> json) {
    return AppError(
      message: json['message'] as String? ?? 'Naməlum xəta baş verdi',
      error: json['error'] as String?,
      statusCode: json['statusCode'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'error': error,
      'statusCode': statusCode,
    };
  }
}
