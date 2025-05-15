import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_management/domain/entities/product.dart';
import 'package:product_management/presentation/viewmodels/product_list/product_list_cubit.dart';
import 'package:product_management/presentation/viewmodels/product_list/product_list_state.dart';

/// Widget chỉ chịu trách nhiệm hiển thị danh sách sản phẩm
/// với load more và pull-to-refresh
class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ProductListCubit>();
    cubit.loadInitial();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final cubit = context.read<ProductListCubit>();
    final state = cubit.state;
    // Khi còn dữ liệu để load thêm, chưa đang load và scroll gần đáy
    if (state is ProductListLoaded &&
        state.hasMore &&
        !_isLoadingMore &&
        _scrollController.position.extentAfter < 200) {
      _isLoadingMore = true;
      cubit.loadMore().whenComplete(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách Sản phẩm')),
      body: RefreshIndicator(
        onRefresh: () => context.read<ProductListCubit>().refresh(),
        child: BlocBuilder<ProductListCubit, ProductListState>(
          builder: (context, state) {
            // 1. Initial / Loading đầu
            if (state is ProductListInitial || state is ProductListLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // 2. Loaded (có thể kèm spinner cuối để loadMore)
            if (state is ProductListLoaded) {
              return ListView.builder(
                controller: _scrollController,
                itemCount: state.products.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < state.products.length) {
                    final p = state.products[index];
                    return ProductItem(product: p);
                  }
                  // index == products.length → spinner load more
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              );
            }

            // 3. Error
            if (state is ProductListError) {
              return Center(child: Text('Lỗi: ${state.message}'));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({Key? key, required this.product}) : super(key: key);

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
      onTap: () {},
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
