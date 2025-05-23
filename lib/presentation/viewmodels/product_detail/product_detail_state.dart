import 'package:product_management/domain/entities/product.dart';

/// Trạng thái của ProductDetail
abstract class ProductDetailState {}

/// Các trạng thái của ProductDetail

///Trạng thái khởi tạo
class ProductDetailInitial extends ProductDetailState {}

///Trạng thái đang tải
class ProductDetailLoading extends ProductDetailState {}

///Trạng thái tải thành công
class ProductDetailLoaded extends ProductDetailState {
  final Product product;
  ProductDetailLoaded(this.product);
}

///Trạng thái tải thất bại
///Trạng thái này sẽ được sử dụng khi có lỗi xảy ra trong quá trình tải dữ liệu
///Ví dụ như không tìm thấy sản phẩm, lỗi mạng, lỗi server...
class ProductDetailError extends ProductDetailState {
  final String message;
  ProductDetailError(this.message);
}

///Trạng thái xóa thành công
class ProductDetailDeleted extends ProductDetailState {
  final String message;
  ProductDetailDeleted(this.message);
}

///Trạng thái xóa thất bại
class ProductDetailDeleteError extends ProductDetailState {
  final String message;
  ProductDetailDeleteError(this.message);
}
