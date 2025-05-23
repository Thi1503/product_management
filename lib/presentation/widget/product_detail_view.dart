// Class trong: dùng context.read, context.watch thoải mái
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_management/core/di/di.dart';
import 'package:product_management/domain/entities/product.dart';
import 'package:product_management/presentation/viewmodels/product_detail/product_detail_cubit.dart';
import 'package:product_management/presentation/viewmodels/product_detail/product_detail_state.dart';
import 'package:product_management/presentation/viewmodels/product_form/product_form_cubit.dart';
import 'package:product_management/presentation/views/product_form_page.dart';

class ProductDetailView extends StatefulWidget {
  final int productId;
  const ProductDetailView({super.key, required this.productId});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  late final ProductDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<ProductDetailCubit>();
    _cubit.loadDetail(widget.productId); // Đọc BlocProvider ở trên
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết sản phẩm')),
      body: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
          if (state is ProductDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProductDetailLoaded) {
            final p = state.product;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (p.cover.isNotEmpty)
                  Image.network(
                    p.cover,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.error),
                  ),
                const SizedBox(height: 16),
                Text(p.name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('Giá: ${p.price}'),
                const SizedBox(height: 8),
                Text('Số lượng: ${p.quantity}'),
              ],
            );
          }
          if (state is ProductDetailError) {
            return Center(child: Text('Lỗi: ${state.message}'));
          }
          // ban đầu có thể mặc định show loading
          return const Center(child: CircularProgressIndicator());
        },
      ),

      // Nút Edit
      floatingActionButton: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                heroTag: 'edit',
                onPressed:
                    state is ProductDetailLoaded
                        ? () async {
                          final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (_) => BlocProvider(
                                    create: (_) => getIt<ProductFormCubit>(),
                                    child: ProductFormPage(
                                      product: state.product,
                                    ),
                                  ),
                            ),
                          );

                          // nếu là Product, cập nhật thẳng; còn bool thì gọi lại API
                          if (result is Product) {
                            context.read<ProductDetailCubit>().updateProduct(
                              result,
                            );
                          } else if (result == true) {
                            _cubit.loadDetail(widget.productId);
                          }
                        }
                        : null,
                child: const Icon(Icons.edit),
              ),
              const SizedBox(height: 8),

              // Nút Delete
              FloatingActionButton(
                heroTag: 'delete',
                onPressed:
                    state is ProductDetailLoading
                        ? null
                        : () async {
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder:
                                (_) => AlertDialog(
                                  title: const Text('Xác nhận xóa'),
                                  content: const Text(
                                    'Bạn có chắc muốn xóa sản phẩm này?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text('Hủy'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: const Text('Xóa'),
                                    ),
                                  ],
                                ),
                          );

                          if (shouldDelete != true) return;

                          // Hiển thị loading dialog
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder:
                                (_) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                          );

                          try {
                            await _cubit.deleteProduct(widget.productId);
                            Navigator.of(context).pop(); // Đóng loading
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Xóa sản phẩm thành công'),
                              ),
                            );
                            Navigator.of(context).pop(true);
                          } catch (e) {
                            Navigator.of(context).pop(); // Đóng loading
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Xóa thất bại: ${e is Exception ? e.toString() : 'Lỗi không xác định'}',
                                ),
                              ),
                            );
                          }
                        },
                child: const Icon(Icons.delete),
              ),
            ],
          );
        },
      ),
    );
  }
}
