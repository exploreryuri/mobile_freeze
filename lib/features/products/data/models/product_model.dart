import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/product.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required String id,
    required String name,
    required String imageUrl,
    required DateTime addedDate,
    required DateTime expiryDate,
  }) : super(
          id: id,
          name: name,
          imageUrl: imageUrl,
          addedDate: addedDate,
          expiryDate: expiryDate,
        );

  factory ProductModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ProductModel(
      id: snapshot.id,
      name: data['name'],
      imageUrl: data['imageUrl'],
      addedDate: DateTime.parse(data['addedDate']),
      expiryDate: DateTime.parse(data['expiryDate']),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'addedDate': addedDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
    };
  }
}
