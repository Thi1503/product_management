import 'package:hive/hive.dart';
import 'package:product_management/data/models/product_model.dart';

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 0;

  @override
  ProductModel read(BinaryReader reader) {
    return ProductModel(
      id: reader.readInt(),
      name: reader.readString(),
      price: reader.readInt(),
      quantity: reader.readInt(),
      cover: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.name);
    writer.writeInt(obj.price);
    writer.writeInt(obj.quantity);
    writer.writeString(obj.cover);
  }
}
