import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failure.dart';
import '../../../../domain/entities/product.dart';

class ProductRemoteService {
  final FirebaseFirestore firestore;

  ProductRemoteService({required this.firestore});

  Future<Either<Failure, void>> addProduct(
      String userId, ProductEntity product) async {
    try {
      print('Attempting to add product to Firestore for user: $userId');
      final docRef = firestore
          .collection('users')
          .doc(userId)
          .collection('products')
          .doc(product.id); // use product id for document id
      await docRef.set({
        'name': product.name,
        'imageUrl': product.imageUrl,
        'addedDate': product.addedDate.toIso8601String(),
        'expiryDate': product.expiryDate.toIso8601String(),
      });
      print('Product successfully added to Firestore');
      return Right(null);
    } catch (e) {
      print('Error adding product to Firestore: $e');
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> updateProduct(
      String userId, ProductEntity product) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('products')
          .doc(product.id)
          .update({
        'name': product.name,
        'imageUrl': product.imageUrl,
        'addedDate': product.addedDate.toIso8601String(),
        'expiryDate': product.expiryDate.toIso8601String(),
      });
      return Right(null);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> deleteProduct(
      String userId, String productId) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('products')
          .doc(productId)
          .delete();
      return Right(null);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, List<ProductEntity>>> getProducts(
      String userId) async {
    try {
      final querySnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('products')
          .get();
      final products = querySnapshot.docs.map((doc) {
        return ProductEntity(
          id: doc.id,
          name: doc['name'],
          imageUrl: doc['imageUrl'],
          addedDate: DateTime.parse(doc['addedDate']),
          expiryDate: DateTime.parse(doc['expiryDate']),
        );
      }).toList();
      return Right(products);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
