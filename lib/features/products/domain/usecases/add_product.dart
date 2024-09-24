import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class AddProduct {
  final ProductRepository repository;

  AddProduct(this.repository);

  Future<Either<Failure, void>> call(
      String userId, ProductEntity product) async {
    return await repository.addProduct(userId, product);
  }
}
