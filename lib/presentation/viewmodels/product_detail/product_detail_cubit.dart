import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:product_management/core/hive/hive_service.dart';
import 'package:product_management/data/models/product_model.dart';
import 'package:product_management/domain/usecases/fetch_product_detail.dart';
import 'package:product_management/presentation/viewmodels/product_detail/product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final FetchProductDetail fetchDetail;
  ProductDetailCubit({required this.fetchDetail})
    : super(ProductDetailInitial());

  Future<void> loadDetail(int id) async {
    // Lấy box đã mở sẵn (không mở lại)
    final box = Hive.box<ProductModel>(HiveService.productCacheBox);

    // 1) Kiểm tra cache
    final cached = box.get(id);
    if (cached != null) {
      emit(ProductDetailLoaded(cached.toProduct()));
      return;
    }

    // 2) Emit loading
    emit(ProductDetailLoading());

    try {
      // 3) Gọi API
      final product = await fetchDetail(id);
      if (product == null) {
        emit(ProductDetailError('Product not found'));
        return;
      }

      // 4) Lưu vào cache
      final model = ProductModel(
        id: product.id,
        name: product.name,
        price: product.price,
        quantity: product.quantity,
        cover: product.cover,
      );
      await box.put(id, model);

      // 5) Emit loaded
      emit(ProductDetailLoaded(product));
    } catch (e) {
      emit(ProductDetailError(e.toString()));
    }
  }

  Future<void> deleteProduct(int id) async {
    final box = Hive.box<ProductModel>(HiveService.productCacheBox);
    if (box.containsKey(id)) {
      await box.delete(id);
    }
    // emit state nếu cần...
  }
}
