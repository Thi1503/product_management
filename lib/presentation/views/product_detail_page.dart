import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_management/domain/entities/product.dart';
import 'package:product_management/main.dart';
import 'package:product_management/presentation/viewmodels/product_detail/product_detail_cubit.dart';
import 'package:product_management/presentation/viewmodels/product_detail/product_detail_state.dart';
import 'package:product_management/presentation/viewmodels/product_form/product_form_cubit.dart';
import 'package:product_management/presentation/views/product_form_page.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;
  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late final ProductDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<ProductDetailCubit>();
    print('--> initState calling loadDetail(${widget.productId})');
    _cubit.loadDetail(widget.productId);
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
                child: const Icon(Icons.edit),
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
                            // cập nhật UI ngay mà không chờ mạng
                            context.read<ProductDetailCubit>().emit(
                              ProductDetailLoaded(result),
                            );
                          } else if (result == true) {
                            _cubit.loadDetail(widget.productId);
                          }
                        }
                        : null,
              ),
              const SizedBox(height: 8),

              // Nút Delete
              FloatingActionButton(
                heroTag: 'delete',
                child: const Icon(Icons.delete),
                onPressed: () async {
                  // 1. Xác nhận
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
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Hủy'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Xóa'),
                            ),
                          ],
                        ),
                  );

                  if (shouldDelete != true) return;

                  // 2. Thực hiện xóa và đợi hoàn tất
                  try {
                    await _cubit.deleteProduct(widget.productId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Xóa sản phẩm thành công')),
                    );
                    // 3. Quay về và báo ListPage refresh
                    Navigator.of(context).pop(true);
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Xóa thất bại: $e')));
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
