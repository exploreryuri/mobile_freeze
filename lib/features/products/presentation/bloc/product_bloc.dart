import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/add_product.dart';
import '../../domain/usecases/update_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/get_products.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final AddProduct addProduct;
  final UpdateProduct updateProduct;
  final DeleteProduct deleteProduct;
  final GetProducts getProducts;

  ProductBloc({
    required this.addProduct,
    required this.updateProduct,
    required this.deleteProduct,
    required this.getProducts,
  }) : super(ProductInitial()) {
    on<ProductAdded>(_onProductAdded);
    on<ProductUpdated>(_onProductUpdated);
    on<ProductDeleted>(_onProductDeleted);
    on<ProductsFetched>(_onProductsFetched);
  }

  Future<void> _onProductAdded(
      ProductAdded event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoading());
      final result = await addProduct(event.userId, event.product);
      result.fold(
        (failure) {
          print('Failed to add product: ${failure.message}');
          emit(ProductError(failure.message));
        },
        (_) {
          print('Product successfully added');
          emit(ProductAddedSuccess());
        },
      );
      add(ProductsFetched(
          event.userId)); // Fetch products after adding a new one
    } catch (e) {
      print('Exception in _onProductAdded: $e');
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onProductUpdated(
      ProductUpdated event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoading());
      final result = await updateProduct(event.userId, event.product);
      result.fold(
        (failure) => emit(ProductError(failure.message)),
        (_) => emit(ProductUpdatedSuccess()),
      );
      add(ProductsFetched(event.userId)); // Fetch products after updating
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onProductDeleted(
      ProductDeleted event, Emitter<ProductState> emit) async {
    print('Event received: ProductDeleted for user ${event.userId}');
    try {
      emit(ProductLoading());
      final result = await deleteProduct(event.userId, event.productId);
      result.fold(
        (failure) {
          print('Failed to delete product: ${failure.message}');
          emit(ProductError(failure.message));
        },
        (_) {
          print('Product successfully deleted');
          emit(ProductDeletedSuccess());
        },
      );
      add(ProductsFetched(event.userId)); // Fetch products after deleting
    } catch (e) {
      print('Exception in _onProductDeleted: $e');
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onProductsFetched(
      ProductsFetched event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoading());
      final result = await getProducts(event.userId);
      result.fold(
        (failure) => emit(ProductError(failure.message)),
        (products) => emit(ProductLoaded(products)),
      );
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
