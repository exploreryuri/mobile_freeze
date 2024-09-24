import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class SignIn {
  final AuthRepository repository;

  SignIn(this.repository);

  Future<Either<Failure, UserEntity>> call(
      String email, String password) async {
    try {
      final user = await repository.signIn(email, password);
      return Right(user);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
