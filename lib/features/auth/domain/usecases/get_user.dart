import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUser {
  final AuthRepository repository;

  GetUser(this.repository);

  Stream<Either<Failure, UserEntity?>> call() {
    return repository.user.map((user) {
      if (user != null) {
        return Right(user);
      } else {
        return Left(Failure(message: 'Something went wrong'));
      }
    });
  }
}
