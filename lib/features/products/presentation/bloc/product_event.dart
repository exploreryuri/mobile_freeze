part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class ProductAdded extends ProductEvent {
  final String userId;
  final ProductEntity product;

  const ProductAdded(this.userId, this.product);

  @override
  List<Object> get props => [userId, product];
}

class ProductUpdated extends ProductEvent {
  final String userId;
  final ProductEntity product;

  const ProductUpdated(this.userId, this.product);

  @override
  List<Object> get props => [userId, product];
}

class ProductDeleted extends ProductEvent {
  final String userId;
  final String productId;

  const ProductDeleted(this.userId, this.productId);

  @override
  List<Object> get props => [userId, productId];
}

class ProductsFetched extends ProductEvent {
  final String userId;

  const ProductsFetched(this.userId);

  @override
  List<Object> get props => [userId];
}
