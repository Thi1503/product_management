import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';

/// Các trạng thái của LoginBloc
abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Khởi tạo
class LoginInitial extends LoginState {}

/// Đang xử lý
class LoginLoading extends LoginState {}

/// Đăng nhập thành công
class LoginSuccess extends LoginState {
  final User user;
  LoginSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

/// Đăng nhập thất bại
class LoginFailure extends LoginState {
  final String message;
  LoginFailure(this.message);

  @override
  List<Object?> get props => [message];
}
