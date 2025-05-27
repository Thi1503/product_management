import 'package:bloc/bloc.dart';
import 'package:product_management/domain/entities/product.dart';
import 'package:product_management/presentation/viewmodels/product_list/product_list_state.dart';
import '../../../domain/usecases/fetch_products_use_case.dart';

/// Cubit quản lý danh sách sản phẩm
class ProductListCubit extends Cubit<ProductListState> {
  final FetchProductsUseCase fetchProducts;
  int _currentPage = 1;
  final int _pageSize = 15;

  ProductListCubit({required this.fetchProducts})
      : super(ProductListState.initial());

  /// Load lần đầu hoặc refresh lại danh sách sản phẩm
  Future<void> loadInitial() async {
    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
      isLoadingMore: false,
      products: state.products, // giữ lại dữ liệu cũ khi loading
    ));
    _currentPage = 1;
    try {
      final List<Product> list = await fetchProducts(_currentPage, _pageSize);
      emit(state.copyWith(
        products: list,
        isLoading: false,
        hasMore: list.length == _pageSize,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Load thêm dữ liệu khi scroll tới cuối danh sách
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;
    emit(state.copyWith(isLoadingMore: true, errorMessage: null));
    _currentPage++;
    try {
      final List<Product> newItems = await fetchProducts(_currentPage, _pageSize);
      final updatedProducts = List<Product>.from(state.products)..addAll(newItems);
      emit(state.copyWith(
        products: updatedProducts,
        isLoadingMore: false,
        hasMore: newItems.length == _pageSize,
        errorMessage: null,
      ));
    } catch (e) {
      _currentPage--;
      emit(state.copyWith(
        isLoadingMore: false,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Refresh lại danh sách sản phẩm
  Future<void> refresh() async {
    await loadInitial();
  }
}
