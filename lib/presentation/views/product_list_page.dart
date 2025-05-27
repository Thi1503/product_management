import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:product_management/presentation/viewmodels/product_list/product_list_cubit.dart';
import 'package:product_management/presentation/viewmodels/product_list/product_list_state.dart';
import 'package:product_management/presentation/views/login_page.dart';
import 'package:product_management/presentation/views/product_form_page.dart';
import 'package:product_management/presentation/widget/product_item.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    // Lấy cubit và load dữ liệu ban đầu khi vào trang
    final cubit = context.read<ProductListCubit>();
    cubit.loadInitial();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  // Hàm xử lý khi người dùng kéo để refresh
  void _onRefresh() async {
    await context.read<ProductListCubit>().refresh();
    _refreshController.refreshCompleted();
    _refreshController.resetNoData();
  }

  // Hàm xử lý khi người dùng kéo để load thêm dữ liệu
  void _onLoading() async {
    final cubit = context.read<ProductListCubit>();
    final prevLength = cubit.state.products.length;
    await cubit.loadMore();
    // Kiểm tra trạng thái hasMore để báo cho controller
    if (!cubit.state.hasMore) {
      _refreshController.loadNoData();
    } else if (cubit.state.products.length > prevLength) {
      _refreshController.loadComplete();
    } else {
      _refreshController.loadComplete();
    }
  }

  /// Hiển thị dialog xác nhận đăng xuất
  void _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Có'),
          ),
        ],
      ),
    );
    if (shouldLogout == true) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách Sản phẩm'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _confirmLogout),
        ],
      ),
      body: BlocBuilder<ProductListCubit, ProductListState>(
        builder: (context, state) {
          // Hiển thị loading khi đang load dữ liệu ban đầu
          if (state.isLoading && state.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Hiển thị lỗi nếu có và chưa có dữ liệu
          if (state.errorMessage != null && state.products.isEmpty) {
            return Center(child: Text(state.errorMessage!));
          }

          // Hiển thị danh sách sản phẩm (và loading more nếu có)
          return SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: ListView.builder(
              key: const PageStorageKey('productList'),
              itemCount: state.products.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (ctx, i) {
                if (i < state.products.length) {
                  return ProductItem(product: state.products[i]);
                } else {
                  // Hiển thị loading indicator ở cuối danh sách khi đang load more
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.of(
            context,
          ).push<bool>(MaterialPageRoute(builder: (ctx) => ProductFormPage()));
          if (created == true) {
            context.read<ProductListCubit>().refresh();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
