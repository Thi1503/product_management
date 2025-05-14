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

  @override
  void initState() {
    super.initState();
    // Lần đầu vào, load trang đầu
    context.read<ProductListCubit>().loadInitial();
    // _scrollController.addListener(_onScroll);
  }

  // void _onScroll() {
  //   // Khi cuộn gần đáy, tự động load thêm
  //   if (_scrollController.position.pixels >=
  //       _scrollController.position.maxScrollExtent - 100) {
  //     // context.read<ProductListCubit>().loadMore();
  //   }
  // }

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
            if (state is ProductListInitial || state is ProductListLoading) {
              // Show loading ngay cả với initial
              return const LoadingIndicator();
            }

            if (state is ProductListLoaded) {
              return ListView.builder(
                controller: _scrollController,
                itemCount: state.products.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.products.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ProductItem(product: state.products[index]);
                },
              );
            }
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
      title: Text(product.name),
      subtitle: Text('Giá: ${product.price}'),
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
