class ApiException implements Exception {
  final String code;
  final String message;
  final int? statusCode;
  final Object? details;

  const ApiException({
    required this.code,
    required this.message,
    this.statusCode,
    this.details,
  });

  factory ApiException.fromJson(Map<String, dynamic> json, {int? statusCode}) {
    final error = json['error'];
    if (error is Map<String, dynamic>) {
      return ApiException(
        code: '${error['code'] ?? 'unknown'}',
        message: '${error['message'] ?? 'Something went wrong.'}',
        statusCode: statusCode,
        details: error['details'],
      );
    }
    return ApiException(
      code: 'unknown',
      message: '${json['message'] ?? 'Something went wrong.'}',
      statusCode: statusCode,
    );
  }

  @override
  String toString() => 'ApiException($code): $message';
}
