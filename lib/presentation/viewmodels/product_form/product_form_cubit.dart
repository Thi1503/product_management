import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:product_management/data/models/models.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/create_product_use_case.dart';
import '../../../domain/usecases/update_product_use_case.dart';

part 'product_form_state.dart';

class ProductFormCubit extends Cubit<ProductFormState> {
  final CreateProductUseCase _createProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;

  ProductFormCubit({
    required CreateProductUseCase createProductUseCase,
    required UpdateProductUseCase updateProductUseCase,
  }) : _createProductUseCase = createProductUseCase,
       _updateProductUseCase = updateProductUseCase,
       super(ProductFormInitial());

  // Thêm sản phẩm mới
  Future<void> createProduct(ProductModel product) async {
    try {
      emit(ProductFormLoading());
      final createdProduct = await _createProductUseCase(product);
      emit(ProductFormSuccess(createdProduct));
    } catch (e) {
      emit(ProductFormError('Failed to create product: $e'));
    }
  }

  // Cập nhật sản phẩm
  Future<void> updateProduct(ProductModel product) async {
    try {
      emit(ProductFormLoading());
      final updatedProduct = await _updateProductUseCase(product);
      emit(ProductFormSuccess(updatedProduct));
    } catch (e) {
      emit(ProductFormError('Failed to update product: $e'));
    }
  }
}
