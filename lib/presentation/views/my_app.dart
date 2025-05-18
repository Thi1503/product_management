import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_management/main.dart';
import 'package:product_management/presentation/viewmodels/login/login_bloc.dart';
import 'package:product_management/presentation/views/login_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Nếu sau này có thêm nhiều Bloc/Cubit, bạn có thể đổi thành MultiBlocProvider
    return BlocProvider<LoginBloc>(
      create: (_) => getIt<LoginBloc>(),
      child: MaterialApp(
        title: 'Product Management',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const LoginPage(),
      ),
    );
  }
}
