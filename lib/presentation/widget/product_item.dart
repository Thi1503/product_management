import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_management/domain/entities/product.dart';
import 'package:product_management/main.dart';
import 'package:product_management/presentation/viewmodels/product_detail/product_detail_cubit.dart';
import 'package:product_management/presentation/viewmodels/product_list/product_list_cubit.dart';
import 'package:product_management/presentation/views/product_detail_page.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipOval(
        child: Image.network(
          product.cover,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.error),
        ),
      ),

      title: Text(product.name),
      subtitle: Text('Giá: ${product.price}'),
      trailing: Text('SL: ${product.quantity}'),
      onTap: () {
        Navigator.of(context)
            .push<bool>(
              MaterialPageRoute(
                builder: (ctx) {
                  return BlocProvider<ProductDetailCubit>(
                    create: (_) => getIt<ProductDetailCubit>(),
                    child: ProductDetailPage(productId: product.id),
                  );
                },
              ),
            )
            .then((_) {
              context.read<ProductListCubit>().refresh();
            });
      },
    );
  }
}
