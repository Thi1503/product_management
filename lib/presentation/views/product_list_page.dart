import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:product_management/presentation/viewmodels/product_list/product_list_cubit.dart';
import 'package:product_management/presentation/viewmodels/product_list/product_list_state.dart';
import 'package:product_management/presentation/views/login_page.dart';
import 'package:product_management/presentation/views/product_form_page.dart';
import 'package:product_management/presentation/widget/product_item.dart';

/// Widget chỉ chịu trách nhiệm hiển thị danh sách sản phẩm
/// với load more và pull-to-refresh
class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  // Controller cho pull-to-refresh và load more
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
    // Giải phóng controller khi widget bị huỷ
    _refreshController.dispose();
    super.dispose();
  }

  // Hàm xử lý khi người dùng kéo để refresh
  void _onRefresh() async {
    await context.read<ProductListCubit>().refresh();
    _refreshController.refreshCompleted();
    _refreshController.resetNoData(); // Reset lại trạng thái load no data
  }

  // Hàm xử lý khi người dùng kéo để load thêm dữ liệu
  void _onLoading() async {
    final cubit = context.read<ProductListCubit>();
    final prevLength = cubit.products.length;
    await cubit.loadMore();
    final loaded =
        cubit.state is ProductListLoaded
            ? cubit.state as ProductListLoaded
            : null;
    // Nếu không còn dữ liệu để load thì báo cho controller
    if (loaded != null && !loaded.hasMore) {
      _refreshController.loadNoData();
    } else if (cubit.products.length > prevLength) {
      // Nếu có dữ liệu mới thì báo load complete
      _refreshController.loadComplete();
    } else {
      // Nếu không có dữ liệu mới nhưng chưa hết thì vẫn báo complete
      _refreshController.loadComplete();
    }
  }

  /// Hiển thị dialog xác nhận đăng xuất
  void _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
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
    // Nếu xác nhận thì chuyển về trang đăng nhập và xoá hết các route trước đó
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
          // Nút đăng xuất
          IconButton(icon: const Icon(Icons.logout), onPressed: _confirmLogout),
        ],
      ),
      body: BlocBuilder<ProductListCubit, ProductListState>(
        builder: (context, state) {
          // Hiển thị loading khi đang load dữ liệu ban đầu
          if (state is ProductListInitial || state is ProductListLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          // Hiển thị loading indicator khi đang load thêm dữ liệu
          if (state is ProductListLoadingMore) {
            return SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView.builder(
                key: const PageStorageKey('productList'),
                itemCount:
                    context.read<ProductListCubit>().products.length +
                    1, // +1 cho loading indicator
                itemBuilder: (ctx, i) {
                  final products = context.read<ProductListCubit>().products;
                  if (i < products.length) {
                    // Hiển thị từng sản phẩm
                    return ProductItem(product: products[i]);
                  } else {
                    // Hiển thị loading indicator ở cuối danh sách
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
            );
          }
          // Hiển thị danh sách sản phẩm khi đã load xong
          if (state is ProductListLoaded) {
            final products = context.read<ProductListCubit>().products;
            return SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView.builder(
                key: const PageStorageKey('productList'),
                itemCount: products.length,
                itemBuilder: (ctx, i) {
                  return ProductItem(product: products[i]);
                },
              ),
            );
          }
          // Trường hợp không có dữ liệu hoặc lỗi
          return const Center(child: Text('Không có sản phẩm nào.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Nút thêm sản phẩm mới
        onPressed: () async {
          final created = await Navigator.of(
            context,
          ).push<bool>(MaterialPageRoute(builder: (ctx) => ProductFormPage()));
          // Nếu thêm thành công thì refresh lại danh sách
          if (created == true) {
            context.read<ProductListCubit>().refresh();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
