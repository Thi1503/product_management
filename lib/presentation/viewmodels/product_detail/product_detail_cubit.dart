import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:product_management/core/hive/hive_service.dart';
import 'package:product_management/data/models/product_model.dart';
import 'package:product_management/domain/entities/product.dart';
import 'package:product_management/domain/usecases/fetch_product_detail_use_case.dart';
import 'package:product_management/presentation/viewmodels/product_detail/product_detail_state.dart';

/// Cubit quản lý trạng thái chi tiết sản phẩm theo Single Class State.
/// Tất cả các trạng thái (đang tải, đã tải, lỗi, đã xóa, lỗi khi xóa) đều được quản lý trong 1 state duy nhất.
class ProductDetailCubit extends Cubit<ProductDetailState> {
  final FetchProductDetailUseCase fetchDetail;

  ProductDetailCubit({required this.fetchDetail})
      : super(ProductDetailState.initial());

  /// Tải chi tiết sản phẩm theo id.
  /// Nếu có dữ liệu trong cache, cập nhật state ngay lập tức.
  /// Sau đó gọi API để cập nhật mới nếu có thay đổi.
  Future<void> loadDetail(int id) async {
    final box = Hive.box<ProductModel>(HiveService.productCacheBox);
    final cached = box.get(id);
    
    if (cached != null) {
      // Nếu có cache, cập nhật state với dữ liệu đã có và tắt loading.
      emit(state.copyWith(product: cached.toProduct(), isLoading: false));
    } else {
      // Nếu chưa có cache, cập nhật state đang tải và xóa lỗi cũ.
      emit(state.copyWith(isLoading: true, errorMessage: null));
    }
    
    try {
      final product = await fetchDetail(id);
      // In debug để so sánh dữ liệu cached và dữ liệu mới lấy được.
      print('Cached product: ${cached?.toProduct()}');
      print('Fetched product: $product');

      // Nếu sản phẩm mới khác với cache (hoặc không có cache), cập nhật cache và state.
      bool isDifferent = cached == null || product != cached.toProduct();
      if (isDifferent) {
        final model = ProductModel(
          id: product.id,
          name: product.name,
          price: product.price,
          quantity: product.quantity,
          cover: product.cover,
        );
        await box.put(id, model);
        emit(state.copyWith(product: product, isLoading: false, errorMessage: null));
      }
      // Nếu không có sự khác nhau, giữ nguyên state cũ.
    } catch (e) {
      // Nếu không có cache và xảy ra lỗi, cập nhật thông báo lỗi cho state.
      if (cached == null) {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    }
  }

  /// Xóa sản phẩm khỏi cache và cập nhật state với thông báo kết quả.
  Future<void> deleteProduct(int id) async {
    try {
      // Gọi use case xóa sản phẩm (điều này giả sử deleteProduct được định nghĩa trong use case).
      await fetchDetail.deleteProduct(id);
      final box = Hive.box<ProductModel>(HiveService.productCacheBox);
      await box.delete(id);
      // Cập nhật state với thông báo xóa thành công và đánh dấu sản phẩm đã bị xóa.
      emit(state.copyWith(isDeleted: true, deleteMessage: 'Xóa sản phẩm thành công'));
    } catch (e) {
      // Nếu xóa thất bại, cập nhật thông báo lỗi khi xóa.
      emit(state.copyWith(deleteMessage: e.toString()));
    }
  }

  /// Cập nhật state với thông tin sản phẩm mới.
  void updateProduct(Product product) {
    emit(state.copyWith(product: product));
  }
}
