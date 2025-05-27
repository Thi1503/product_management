import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_management/core/di/di.dart';
import 'package:product_management/domain/entities/product.dart';
import 'package:product_management/presentation/viewmodels/product_form/product_form_cubit.dart';
import 'package:product_management/presentation/widget/product_form_view.dart';

class ProductFormPage extends StatelessWidget {
  final Product? product;
  const ProductFormPage({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductFormCubit>(
      create: (_) => getIt<ProductFormCubit>(),
      child: ProductFormView(product: product),
    );
  }
}
