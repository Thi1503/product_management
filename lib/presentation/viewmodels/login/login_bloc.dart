import 'package:bloc/bloc.dart';
import 'login_event.dart';
import 'login_state.dart';
import '../../../domain/usecases/login_usecase.dart';

/// Bloc quản lý nghiệp vụ đăng nhập
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc({required this.loginUseCase}) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  /// Xử lý sự kiện đăng nhập
  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final user = await loginUseCase(
        event.taxCode,
        event.username,
        event.password,
      );
      emit(LoginSuccess(user));
    } catch (e) {
      // emit(LoginFailure(e.toString()));
      emit(LoginFailure("Đăng nhập thất bại"));
    }
  }

  /// Xử lý đăng xuất
  void _onLogoutRequested(LogoutRequested event, Emitter<LoginState> emit) {
    emit(LoginInitial());
  }
}
