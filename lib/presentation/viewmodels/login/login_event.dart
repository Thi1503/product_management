import 'package:equatable/equatable.dart';

/// Các sự kiện của LoginBloc
abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Người dùng nhấn nút đăng nhập
class LoginSubmitted extends LoginEvent {
  final String taxCode;
  final String username;
  final String password;

  LoginSubmitted({
    required this.taxCode,
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [taxCode, username, password];
}

/// Người dùng yêu cầu đăng xuất
class LogoutRequested extends LoginEvent {}
