import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/product_repository.dart';

class DeleteProduct {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  Future<Either<Failure, void>> call(String userId, String productId) async {
    try {
      await repository.deleteProduct(userId, productId);
      return Right(null);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
