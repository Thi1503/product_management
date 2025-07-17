import 'package:bloc/bloc.dart';
import 'package:product_management/domain/entities/product.dart';
import 'package:product_management/presentation/viewmodels/product_list/product_list_state.dart';
import '../../../domain/usecases/fetch_products_use_case.dart';

/// Cubit quản lý danh sách sản phẩm theo Single Class State.
/// Danh sách sản phẩm được lưu trực tiếp trong state.
/// Nếu thêm sản phẩm mới thì dùng:
///   emit(ProductListLoaded([...state.products, ...newProducts]));
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
      products: state.products, // giữ lại danh sách hiện có (nếu cần)
    ));
    _currentPage = 1;
    try {
      final List<Product> list = await fetchProducts(_currentPage, _pageSize);
      // Cập nhật danh sách sản phẩm, ghi đè dữ liệu cũ khi refresh
      emit(state.copyWith(
        products: list,
        isLoading: false,
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
    if (state.isLoadingMore) return;
    emit(state.copyWith(isLoadingMore: true, errorMessage: null));
    _currentPage++;
    try {
      final List<Product> newItems = await fetchProducts(_currentPage, _pageSize);
      if (newItems.isNotEmpty) {
        // Nối thêm danh sách sản phẩm mới vào danh sách hiện có
        final updatedProducts = [...state.products, ...newItems];
        emit(state.copyWith(
          products: updatedProducts,
          isLoadingMore: false,
          errorMessage: null,
        ));
      } else {
        // Nếu API trả về danh sách rỗng, xem như không còn dữ liệu thêm
        emit(state.copyWith(
          isLoadingMore: false,
          errorMessage: null,
        ));
      }
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
