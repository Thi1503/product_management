import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_management/presentation/viewmodels/product_detail/product_detail_cubit.dart';
import 'package:product_management/presentation/viewmodels/product_detail/product_detail_state.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;
  const ProductDetailPage({Key? key, required this.productId})
    : super(key: key);

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
                  Image.network(p.cover, height: 200, fit: BoxFit.cover),
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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'edit',
            child: const Icon(Icons.edit),
            onPressed: () {
              /* ... */
            },
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
                      content: const Text('Bạn có chắc muốn xóa sản phẩm này?'),
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
      ),
    );
  }
}
