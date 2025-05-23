/// Model đại diện cho response trả về danh sách từ API chuẩn
class BaseResponseList<T> {
  final bool success;
  final String message;
  final List<T> data;

  BaseResponseList({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BaseResponseList.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return BaseResponseList(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((e) => fromJsonT(e))
          .toList(),
    );
  }
}