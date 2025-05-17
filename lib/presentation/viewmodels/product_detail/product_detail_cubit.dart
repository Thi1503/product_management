import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:product_management/core/hive/hive_service.dart';
import 'package:product_management/data/models/product_model.dart';
import 'package:product_management/domain/entities/product.dart';
import 'package:product_management/domain/usecases/fetch_product_detail.dart';
import 'package:product_management/presentation/viewmodels/product_detail/product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final FetchProductDetail fetchDetail;
  ProductDetailCubit({required this.fetchDetail})
    : super(ProductDetailInitial());

  Future<void> loadDetail(int id) async {
    final box = Hive.box<ProductModel>(HiveService.productCacheBox);

    final cached = box.get(id);
    if (cached != null) {
      emit(ProductDetailLoaded(cached.toProduct()));
    } else {
      emit(ProductDetailLoading());
    }

    try {
      final product = await fetchDetail(id);
      // In debug hai đối tượng để so sánh
      print('Cached product: ${cached?.toProduct()}');
      print('Fetched product: $product');
      // So sánh product mới với cached (dữ liệu cũ)
      bool isDifferent =
          cached == null || !_isProductEqual(product, cached.toProduct());

      if (isDifferent) {
        final model = ProductModel(
          id: product.id,
          name: product.name,
          price: product.price,
          quantity: product.quantity,
          cover: product.cover,
        );
        await box.put(id, model);
        emit(ProductDetailLoaded(product));
      }
      // Nếu giống nhau thì không emit lại
    } catch (e) {
      if (cached == null) {
        emit(ProductDetailError(e.toString()));
      }
    }
  }

  /// Hàm so sánh 2 product domain có giống nhau không
  bool _isProductEqual(Product a, Product b) {
    return a.id == b.id &&
        a.name == b.name &&
        a.price == b.price &&
        a.quantity == b.quantity &&
        a.cover == b.cover;
  }

  /// Xóa sản phẩm
  /// Xóa cache
  /// Nếu xóa thành công thì emit trạng thái xóa thành công
  /// Nếu xóa thất bại thì emit trạng thái xóa thất bại
  Future<void> deleteProduct(int id) async {
    try {
      await fetchDetail.deleteProduct(id);
      final box = Hive.box<ProductModel>(HiveService.productCacheBox);
      await box.delete(id);
      emit(ProductDetailDeleted('Xóa sản phẩm thành công'));
    } catch (e) {
      emit(ProductDetailDeleteError(e.toString()));
    }
  }
}
