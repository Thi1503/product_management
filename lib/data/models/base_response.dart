class BaseResponse<T> {
  final bool success;
  final String message;
  final T data;

  BaseResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return BaseResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: fromJsonT(json['data']),
    );
  }
}