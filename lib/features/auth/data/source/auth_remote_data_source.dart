import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> signUpWithEmailAndPassword(
      String email, String password, String name);
  Future<void> signOut();
  Stream<UserModel?> getUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = userCredential.user;

      if (user != null) {
        final userSnapshot =
            await firestore.collection('users').doc(user.uid).get();
        return UserModel.fromSnapshot(userSnapshot);
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      throw Exception("SignIn failed: $e");
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = userCredential.user;

      if (user != null) {
        final userModel = UserModel(
          id: user.uid,
          email: email,
          name: name,
          profileImageUrl: '', // Initialize with empty string or default URL
        );

        await firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toDocument());
        return userModel;
      } else {
        throw Exception("User registration failed");
      }
    } catch (e) {
      throw Exception("SignUp failed: $e");
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Stream<UserModel?> getUser() {
    return firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user != null) {
        final userSnapshot =
            await firestore.collection('users').doc(user.uid).get();
        return UserModel.fromSnapshot(userSnapshot);
      } else {
        return null;
      }
    });
  }
}
