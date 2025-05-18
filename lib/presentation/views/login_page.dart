import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:product_management/core/constants.dart';
import 'package:product_management/core/hive/hive_service.dart';
import 'package:product_management/main.dart';
import 'package:product_management/presentation/viewmodels/product_list/product_list_cubit.dart';

import 'package:product_management/presentation/views/product_list_page.dart';

import '../viewmodels/login/login_bloc.dart';
import '../viewmodels/login/login_event.dart';
import '../viewmodels/login/login_state.dart';

/// Widget màn Login
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _taxController = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _autovalidate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final box = GetIt.I<HiveService>().getAuthBox();
    // Tiền điền nếu có
    _taxController.text = box.get(Constants.savedTaxCodeKey, defaultValue: '');
    _userController.text = box.get(Constants.savedUserKey, defaultValue: '');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _taxController.dispose();
    _userController.dispose();
    _passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng nhập')),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder:
                    (_) => BlocProvider<ProductListCubit>(
                      create: (_) => getIt<ProductListCubit>(),
                      child: ProductListPage(),
                    ),
              ),
            );
          } else if (state is LoginFailure) {
            // Hiển thị SnackBar khi login thất bại
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode:
                _autovalidate
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
            child: Column(
              children: [
                TextFormField(
                  controller: _taxController,
                  decoration: const InputDecoration(labelText: 'Mã số thuế'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mã số thuế không được để trống';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _userController,
                  decoration: const InputDecoration(labelText: 'Tài khoản'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tài khoản không được để trống';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passController,
                  decoration: const InputDecoration(labelText: 'Mật khẩu'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mật khẩu không được để trống';
                    }
                    if (value.length < 6 || value.length > 50) {
                      return 'Mật khẩu phải từ 6 đến 50 ký tự';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    if (state is LoginLoading) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: () {
                        setState(() => _autovalidate = true);
                        if (_formKey.currentState!.validate()) {
                          context.read<LoginBloc>().add(
                            LoginSubmitted(
                              taxCode: _taxController.text,
                              username: _userController.text,
                              password: _passController.text,
                            ),
                          );
                        }
                      },
                      child: const Text('Đăng nhập'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
