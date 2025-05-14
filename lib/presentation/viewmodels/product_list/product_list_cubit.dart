import 'package:bloc/bloc.dart';

import 'package:product_management/presentation/viewmodels/product_list/product_list_state.dart';
import '../../../domain/usecases/fetch_products.dart';

/// Cubit quản lý danh sách sản phẩm
class ProductListCubit extends Cubit<ProductListState> {
  final FetchProducts fetchProducts;
  int _currentPage = 1;
  int _pageSize = 100;

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

  /// Refresh data
  Future<void> refresh() async {
    _currentPage = 1;
    await loadInitial();
  }
}
