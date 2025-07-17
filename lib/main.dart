// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_management/presentation/views/login_page.dart';

import 'core/bloc/bloc_observer.dart';
import 'core/hive/hive_service.dart';
import 'core/di/di.dart'; // import file di.dart

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await HiveService.init();
  await initDependencies(); // gọi hàm khởi tạo dependencies

  runApp(const MyApp());
}

// Không inject LoginBloc ở đây nữa!
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
    );
  }
}
