import 'package:equatable/equatable.dart';
import 'package:product_management/domain/entities/product.dart';

class ProductListState extends Equatable {
  final List<Product> products;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? errorMessage;

  const ProductListState({
    required this.products,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    this.errorMessage,
  });

  factory ProductListState.initial() {
    return const ProductListState(
      products: [],
      isLoading: false,
      isLoadingMore: false,
      hasMore: true,
      errorMessage: null,
    );
  }

  ProductListState copyWith({
    List<Product>? products,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? errorMessage,
  }) {
    return ProductListState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    products,
    isLoading,
    isLoadingMore,
    hasMore,
    errorMessage,
  ];
}
