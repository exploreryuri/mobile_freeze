import 'package:dartz/dartz.dart';
import 'package:mobile_freeze/core/error/failure.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class UpdateProduct {
  final ProductRepository repository;

  UpdateProduct(this.repository);

  Future<Either<Failure, void>> call(
      String userId, ProductEntity product) async {
    try {
      await repository.updateProduct(userId, product);
      return Right(null);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
