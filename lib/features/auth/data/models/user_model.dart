import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user.dart';

class UserModel extends UserEntity {
  UserModel({
    required String id,
    required String email,
    required String name,
    required String profileImageUrl,
  }) : super(
            id: id, email: email, name: name, profileImageUrl: profileImageUrl);

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      id: snapshot.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'email': email,
      'name': name,
      'profileImageUrl': profileImageUrl,
    };
  }
}
