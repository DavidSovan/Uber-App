class ApiResponse<T> {
  final String status;
  final T? data;
  final String message;
  final int statusCode;

  ApiResponse({
    required this.status,
    this.data,
    required this.message,
    required this.statusCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T? Function(Map<String, dynamic>?) dataFromJson,
  ) {
    // Safely handle status field
    String status = 'unknown';
    if (json['status'] != null) {
      status = json['status'].toString();
    }

    // Safely handle message field
    String message = 'No message provided';
    if (json['message'] != null) {
      message = json['message'].toString();
    }

    // Safely handle status_code field
    int statusCode = 0;
    if (json['status_code'] != null) {
      if (json['status_code'] is int) {
        statusCode = json['status_code'] as int;
      } else {
        statusCode = int.tryParse(json['status_code'].toString()) ?? 0;
      }
    }

    // Safely handle data field
    T? data;
    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      data = dataFromJson(json['data'] as Map<String, dynamic>);
    }

    return ApiResponse<T>(
      status: status,
      data: data,
      message: message,
      statusCode: statusCode,
    );
  }
}
