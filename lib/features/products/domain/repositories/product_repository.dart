import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, void>> addProduct(
      String userId, ProductEntity product);
  Future<Either<Failure, void>> updateProduct(
      String userId, ProductEntity product);
  Future<Either<Failure, void>> deleteProduct(String userId, String productId);
  Future<Either<Failure, List<ProductEntity>>> getProducts(String userId);
}
