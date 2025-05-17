import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_management/domain/entities/product.dart';
import 'package:product_management/main.dart';
import 'package:product_management/presentation/viewmodels/product_detail/product_detail_cubit.dart';
import 'package:product_management/presentation/viewmodels/product_form/product_form_cubit.dart';
import 'package:product_management/presentation/viewmodels/product_list/product_list_cubit.dart';
import 'package:product_management/presentation/viewmodels/product_list/product_list_state.dart';
import 'package:product_management/presentation/views/login_page.dart';
import 'package:product_management/presentation/views/product_detail_page.dart';
import 'package:product_management/presentation/views/product_form_page.dart';

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

  /// Hàm lắng nghe scroll
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currScroll = _scrollController.position.pixels;

    // khi đã ở đáy (và không phải tại top), trigger loadMore
    if (currScroll >= maxScroll && !_isLoadingMore) {
      final cubit = context.read<ProductListCubit>();
      final state = cubit.state;
      if (state is ProductListLoaded && state.hasMore) {
        _isLoadingMore = true;
        cubit.loadMore().whenComplete(() => _isLoadingMore = false);
      }
    }
  }

  /// Xác nhận đăng xuất
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
    if (shouldLogout == true) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  /// Hủy scroll controller
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
              return NotificationListener<ScrollNotification>(
                onNotification: (notif) {
                  if (notif.metrics.pixels >= notif.metrics.maxScrollExtent &&
                      !_isLoadingMore) {
                    _isLoadingMore = true;
                    context.read<ProductListCubit>().loadMore().whenComplete(
                      () => _isLoadingMore = false,
                    );
                  }
                  return false;
                },
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.products.length + (state.hasMore ? 1 : 0),
                  itemBuilder: (ctx, i) {
                    if (i < state.products.length) {
                      return ProductItem(product: state.products[i]);
                    }
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
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
        onPressed: () async {
          final created = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder:
                  (ctx) => BlocProvider<ProductFormCubit>(
                    create: (_) => getIt<ProductFormCubit>(),
                    child: ProductFormPage(),
                  ),
            ),
          );
          if (created == true) {
            // chỉ refresh khi thực sự tạo mới/sửa thành công
            context.read<ProductListCubit>().refresh();
          }
        },

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

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
