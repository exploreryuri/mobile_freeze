import '../entities/user.dart';

abstract class AuthRepository {
  Future<UserEntity> signIn(String email, String password);
  Future<UserEntity> signUp(String email, String password, String name);
  Future<void> signOut();
  Stream<UserEntity?> get user;
}
