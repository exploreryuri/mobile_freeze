import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class SignUp {
  final AuthRepository repository;

  SignUp(this.repository);

  Future<Either<Failure, UserEntity>> call(
      String email, String password, String name) async {
    try {
      final user = await repository.signUp(email, password, name);
      return Right(user);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
