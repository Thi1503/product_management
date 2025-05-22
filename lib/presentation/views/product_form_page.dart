import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_management/core/di/di.dart';
import 'package:product_management/domain/entities/product.dart';
import 'package:product_management/presentation/viewmodels/product_form/product_form_cubit.dart';
import 'package:product_management/presentation/views/product_form_view.dart';

class ProductFormPage extends StatelessWidget {
  final Product? product;
  const ProductFormPage({Key? key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductFormCubit>(
      create: (_) => getIt<ProductFormCubit>(),
      child: ProductFormView(product: product),
    );
  }
}
