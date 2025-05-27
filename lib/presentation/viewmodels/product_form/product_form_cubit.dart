import 'package:bloc/bloc.dart';
import 'package:product_management/data/models/models.dart';
import '../../../domain/usecases/create_product_use_case.dart';
import '../../../domain/usecases/update_product_use_case.dart';
import 'product_form_state.dart';

class ProductFormCubit extends Cubit<ProductFormState> {
  final CreateProductUseCase _createProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;

  ProductFormCubit({
    required CreateProductUseCase createProductUseCase,
    required UpdateProductUseCase updateProductUseCase,
  }) : _createProductUseCase = createProductUseCase,
       _updateProductUseCase = updateProductUseCase,
       super(ProductFormState.initial());

  // Thêm sản phẩm mới
  Future<void> createProduct(ProductModel product) async {
    try {
      // Cập nhật state: đang loading, xóa thông báo lỗi cũ
      emit(state.copyWith(isLoading: true, errorMessage: null));
      final createdProduct = await _createProductUseCase(product);
      // Cập nhật state: đã thành công, lưu product mới và tắt loading
      emit(
        state.copyWith(
          isLoading: false,
          product: createdProduct,
          errorMessage: null,
        ),
      );
    } catch (e) {
      // Cập nhật state: tắt loading và hiển thị thông báo lỗi
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to create product: $e',
        ),
      );
    }
  }

  // Cập nhật sản phẩm
  Future<void> updateProduct(ProductModel product) async {
    try {
      // Cập nhật state: đang loading, xóa thông báo lỗi cũ
      emit(state.copyWith(isLoading: true, errorMessage: null));
      final updatedProduct = await _updateProductUseCase(product);
      // Cập nhật state: đã thành công, lưu product đã update và tắt loading
      emit(
        state.copyWith(
          isLoading: false,
          product: updatedProduct,
          errorMessage: null,
        ),
      );
    } catch (e) {
      // Cập nhật state: tắt loading và hiển thị thông báo lỗi
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to update product: $e',
        ),
      );
    }
  }
}
