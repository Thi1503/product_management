import 'package:equatable/equatable.dart';
import 'package:product_management/domain/entities/product.dart';

/// Single Class State cho ProductDetail
/// Gom tất cả trạng thái (loading, loaded, error, deleted, delete error) vào một class duy nhất.
/// Giúp giữ lại dữ liệu cũ khi chuyển trạng thái và đơn giản hóa quản lý UI.
class ProductDetailState extends Equatable {
  /// Thông tin sản phẩm (nếu đã tải thành công)
  final Product? product;

  /// Đang tải dữ liệu hay không
  final bool isLoading;

  /// Thông báo lỗi (nếu có)
  final String? errorMessage;

  /// Đã xóa thành công hay chưa
  final bool isDeleted;

  /// Thông báo khi xóa (thành công hoặc thất bại)
  final String? deleteMessage;

  const ProductDetailState({
    this.product,
    this.isLoading = false,
    this.errorMessage,
    this.isDeleted = false,
    this.deleteMessage,
  });

  /// Trạng thái khởi tạo ban đầu
  factory ProductDetailState.initial() {
    return const ProductDetailState();
  }

  /// Tạo một bản sao mới với các giá trị cập nhật
  ProductDetailState copyWith({
    Product? product,
    bool? isLoading,
    String? errorMessage,
    bool? isDeleted,
    String? deleteMessage,
  }) {
    return ProductDetailState(
      product: product ?? this.product,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isDeleted: isDeleted ?? this.isDeleted,
      deleteMessage: deleteMessage,
    );
  }

  @override
  List<Object?> get props => [product, isLoading, errorMessage, isDeleted, deleteMessage];
}
