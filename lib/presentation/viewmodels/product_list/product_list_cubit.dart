import 'package:bloc/bloc.dart';

import 'package:product_management/presentation/viewmodels/product_list/product_list_state.dart';
import '../../../domain/usecases/fetch_products.dart';

/// Cubit quản lý danh sách sản phẩm
class ProductListCubit extends Cubit<ProductListState> {
  final FetchProducts fetchProducts;
  int _currentPage = 1;
  final int _pageSize = 100;

  ProductListCubit({required this.fetchProducts}) : super(ProductListInitial());

  /// Load lần đầu
  Future<void> loadInitial() async {
    emit(ProductListLoading());
    try {
      final list = await fetchProducts(_currentPage, _pageSize);
      emit(ProductListLoaded(products: list, hasMore: list.isNotEmpty));
    } catch (e) {
      emit(ProductListError(e.toString()));
    }
  }

  /// Load thêm
  /// Tăng trang hiện tại lên 1
  Future<void> loadMore() async {
    // Chỉ loadMore khi đã có dữ liệu và vẫn còn trang
    if (state is ProductListLoaded) {
      final current = state as ProductListLoaded;
      if (!current.hasMore) return;

      // Emit state loadingMore với danh sách cũ
      emit(ProductListLoadingMore(current.products));

      try {
        _currentPage++;
        final newItems = await fetchProducts(_currentPage, _pageSize);
        final all = [...current.products, ...newItems];
        emit(ProductListLoaded(products: all, hasMore: newItems.isNotEmpty));
      } catch (e) {
        _currentPage--; // rollback page nếu lỗi
        emit(ProductListError(e.toString()));
      }
    }
  }

  /// Refresh data
  Future<void> refresh() async {
    _currentPage = 1;
    await loadInitial();
  }
}
