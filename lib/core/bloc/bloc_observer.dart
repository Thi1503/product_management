import 'package:bloc/bloc.dart';

/// Custom BlocObserver để quan sát mọi event, transition, change và error trong các Bloc/Cubit
class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('[Bloc Event] ${bloc.runtimeType} -> $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('[Bloc Change] ${bloc.runtimeType} -> $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('[Bloc Transition] ${bloc.runtimeType} -> $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print('[Bloc Error] ${bloc.runtimeType} -> $error');
  }
}

// Để sử dụng, thêm vào main():
// Bloc.observer = SimpleBlocObserver();
