import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:product_management/core/constants.dart';
import 'package:product_management/core/hive/hive_service.dart';
import 'package:product_management/main.dart';
import 'package:product_management/presentation/viewmodels/product_list/product_list_cubit.dart';

import 'package:product_management/presentation/views/product_list_page.dart';

import '../../core/utils/validators.dart';
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
                  decoration: const InputDecoration(labelText: 'Tax Code'),
                  validator: Validators.validateTaxCode,
                ),
                TextFormField(
                  controller: _userController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: Validators.validateUserName,
                ),
                TextFormField(
                  controller: _passController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: Validators.validatePassword,
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
