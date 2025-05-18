import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_management/data/models/product_model.dart';
import 'package:product_management/domain/entities/product.dart';
import 'package:product_management/presentation/viewmodels/product_form/product_form_cubit.dart';

class ProductFormPage extends StatefulWidget {
  final Product? product;
  const ProductFormPage({Key? key, this.product}) : super(key: key);

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;
  late final TextEditingController _coverController;
  bool _autovalidate = false;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
    _quantityController = TextEditingController(
      text: widget.product?.quantity.toString() ?? '',
    );
    _coverController = TextEditingController(text: widget.product?.cover ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _coverController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final newProduct = ProductModel(
        id: widget.product?.id ?? 0,
        name: _nameController.text.trim(),
        price: int.parse(_priceController.text),
        quantity: int.parse(_quantityController.text),
        cover: _coverController.text.trim(),
      );
      final cubit = context.read<ProductFormCubit>();
      if (widget.product == null) {
        cubit.createProduct(newProduct);
      } else {
        cubit.updateProduct(newProduct);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductFormCubit, ProductFormState>(
      listener: (ctx, state) {
        if (state is ProductFormSuccess) {
          FocusScope.of(ctx).unfocus();
          Navigator.of(ctx).pop(true);
        }
        if (state is ProductFormError) {
          ScaffoldMessenger.of(
            ctx,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (ctx, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.product == null ? 'Tạo Sản Phẩm' : 'Cập Nhật Sản Phẩm',
            ),
          ),
          body:
              state is ProductFormLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      autovalidateMode:
                          _autovalidate
                              ? AutovalidateMode.always
                              : AutovalidateMode.disabled,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Tên sản phẩm',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Vui lòng nhập tên sản phẩm';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Giá sản phẩm',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập giá';
                              }
                              final price = int.tryParse(value);
                              if (price == null || price < 0) {
                                return 'Giá không hợp lệ';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _quantityController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Số lượng sản phẩm',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập số lượng';
                              }
                              final qty = int.tryParse(value);
                              if (qty == null || qty < 0) {
                                return 'Số lượng không hợp lệ';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _coverController,
                            keyboardType: TextInputType.url,
                            decoration: const InputDecoration(
                              labelText: 'Link ảnh sản phẩm',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Vui lòng nhập link ảnh';
                              }
                              final uri = Uri.tryParse(value);
                              if (uri == null || !uri.hasAbsolutePath) {
                                return 'Link không hợp lệ';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _autovalidate = true;
                                });
                                _onSave();
                              },
                              child: Text(
                                widget.product == null
                                    ? 'Tạo Sản Phẩm'
                                    : 'Cập Nhật',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
        );
      },
    );
  }
}
