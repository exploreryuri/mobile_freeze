import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';
import '../source/database/remote/product_remote_service.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteService remoteService;

  ProductRepositoryImpl({required this.remoteService});

  @override
  Future<Either<Failure, void>> addProduct(
      String userId, ProductEntity product) async {
    print('Adding product: ${product.toString()} for user: $userId');
    final result = await remoteService.addProduct(
      userId,
      ProductModel(
        id: product.id,
        name: product.name,
        imageUrl: product.imageUrl,
        addedDate: product.addedDate,
        expiryDate: product.expiryDate,
      ),
    );
    result.fold(
      (failure) =>
          print('Failed to add product to remote service: ${failure.message}'),
      (_) => print('Product successfully added to remote service'),
    );
    return result;
  }

  @override
  Future<Either<Failure, void>> updateProduct(
      String userId, ProductEntity product) async {
    return await remoteService.updateProduct(
      userId,
      ProductModel(
        id: product.id,
        name: product.name,
        imageUrl: product.imageUrl,
        addedDate: product.addedDate,
        expiryDate: product.expiryDate,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> deleteProduct(
      String userId, String productId) async {
    return await remoteService.deleteProduct(userId, productId);
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts(
      String userId) async {
    final result = await remoteService.getProducts(userId);
    return result.fold(
      (failure) => Left(failure),
      (products) => Right(products
          .map((product) => ProductEntity(
                id: product.id,
                name: product.name,
                imageUrl: product.imageUrl,
                addedDate: product.addedDate,
                expiryDate: product.expiryDate,
              ))
          .toList()),
    );
  }
}
