import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../source/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> signIn(String email, String password) async {
    try {
      return await remoteDataSource.signInWithEmailAndPassword(email, password);
    } catch (e) {
      throw Exception("SignIn failed: $e");
    }
  }

  @override
  Future<UserEntity> signUp(String email, String password, String name) async {
    try {
      return await remoteDataSource.signUpWithEmailAndPassword(
          email, password, name);
    } catch (e) {
      throw Exception("SignUp failed: $e");
    }
  }

  @override
  Future<void> signOut() async {
    return await remoteDataSource.signOut();
  }

  @override
  Stream<UserEntity?> get user {
    return remoteDataSource.getUser().map((user) => user);
  }
}
