import 'package:product_management/domain/entities/product.dart';

/// Các trạng thái của ProductListCubit
abstract class ProductListState {
  const ProductListState();
}

/// Khởi tạo
class ProductListInitial extends ProductListState {}

/// Đang load
class ProductListLoading extends ProductListState {}

/// Load thành công
class ProductListLoaded extends ProductListState {
  final List<Product> products;
  final bool hasMore;

  const ProductListLoaded({required this.products, required this.hasMore});

  /// Tạo state mới từ state hiện tại
  ProductListLoaded copyWith({List<Product>? products, bool? hasMore}) {
    return ProductListLoaded(
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// Load lỗi
class ProductListError extends ProductListState {
  final String message;
  const ProductListError(this.message);
}
