/// Model đại diện dữ liệu User trả về từ API (chỉ gồm token)
class UserModel {
  final String token;

  UserModel({required this.token});

  /// Tạo từ JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(token: json['token'] as String);
  }

  /// Chuyển sang JSON
  Map<String, dynamic> toJson() => {'token': token};
}
