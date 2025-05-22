// Class ngoài: bọc BlocProvider
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_management/core/di/di.dart';
import 'package:product_management/presentation/viewmodels/product_detail/product_detail_cubit.dart';
import 'package:product_management/presentation/views/product_detail_view.dart';

class ProductDetailPage extends StatelessWidget {
  final int productId;
  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductDetailCubit>(
      create: (_) => getIt<ProductDetailCubit>(),
      child: ProductDetailView(productId: productId),
    );
  }
}
