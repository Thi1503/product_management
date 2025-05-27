import 'package:equatable/equatable.dart';
import 'package:product_management/domain/entities/product.dart';

/// Single Class State cho ProductForm.
/// Tất cả trạng thái của form (đang submit, thành công, lỗi) đều được quản lý trong 1 state duy nhất.
class ProductFormState extends Equatable {
  /// Đang submit form hay không
  final bool isLoading;

  /// Sản phẩm được tạo/sửa thành công (nếu có)
  final Product? product;

  /// Thông báo lỗi (nếu có)
  final String? errorMessage;

  const ProductFormState({
    this.isLoading = false,
    this.product,
    this.errorMessage,
  });

  /// Trạng thái khởi tạo ban đầu
  factory ProductFormState.initial() {
    return const ProductFormState();
  }

  /// Tạo một bản sao mới với các giá trị cập nhật
  ProductFormState copyWith({
    bool? isLoading,
    Product? product,
    String? errorMessage,
  }) {
    return ProductFormState(
      isLoading: isLoading ?? this.isLoading,
      product: product ?? this.product,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, product, errorMessage];
}
