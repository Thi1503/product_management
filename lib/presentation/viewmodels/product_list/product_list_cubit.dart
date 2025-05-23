import 'package:bloc/bloc.dart';
import 'package:product_management/domain/entities/product.dart';

import 'package:product_management/presentation/viewmodels/product_list/product_list_state.dart';
import '../../../domain/usecases/fetch_products_use_case.dart';

/// Cubit quản lý danh sách sản phẩm
class ProductListCubit extends Cubit<ProductListState> {
  final FetchProductsUseCase fetchProducts; // Use case để lấy danh sách sản phẩm
  int _currentPage = 1; // Trang hiện tại
  final int _pageSize = 15; // Số lượng sản phẩm mỗi trang
  bool _hasMore = true; // Cờ kiểm tra còn dữ liệu để load tiếp không
  List<Product> products = []; // Danh sách sản phẩm hiện tại

  ProductListCubit({required this.fetchProducts}) : super(ProductListInitial());

  /// Load lần đầu hoặc refresh lại danh sách sản phẩm
  Future<void> loadInitial() async {
    emit(ProductListLoading()); // Phát trạng thái loading
    _currentPage = 1;
    _hasMore = true;
    try {
      print('LoadInitial: page=$_currentPage');
      final List<Product> list = await fetchProducts(_currentPage, _pageSize); // Lấy dữ liệu từ use case
      print('LoadInitial: fetched ${list.length} items');
      products = List.from(list); // Gán lại danh sách sản phẩm
      _hasMore = list.length == _pageSize; // Kiểm tra còn dữ liệu không
      emit(ProductListLoaded(products: products, hasMore: _hasMore)); // Phát trạng thái loaded
    } catch (e) {
      emit(ProductListError(e.toString())); // Phát trạng thái lỗi
    }
  }

  /// Load thêm dữ liệu khi scroll tới cuối danh sách
  Future<void> loadMore() async {
    if (!_hasMore) return; // Nếu không còn dữ liệu thì không load nữa
    if (state is ProductListLoaded || state is ProductListLoadingMore) {
      emit(ProductListLoadingMore(products)); // Phát trạng thái loading more
      try {
        _currentPage++; // Tăng trang
        print('LoadMore: page=$_currentPage');
        final List<Product> newItems = await fetchProducts(
          _currentPage,
          _pageSize,
        ); // Lấy thêm dữ liệu
        print('LoadMore: fetched ${newItems.length} items');
        products.addAll(newItems); // Thêm vào danh sách hiện tại
        _hasMore = newItems.length == _pageSize; // Kiểm tra còn dữ liệu không
        emit(ProductListLoaded(products: products, hasMore: _hasMore)); // Phát trạng thái loaded
      } catch (e) {
        _currentPage--; // Nếu lỗi thì giảm lại trang
        emit(ProductListError(e.toString())); // Phát trạng thái lỗi
      }
    }
  }

  /// Refresh lại danh sách sản phẩm
  Future<void> refresh() async {
    await loadInitial();
  }
}
