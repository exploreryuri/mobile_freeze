import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/user_repository.dart';

class SignOut {
  final AuthRepository repository;

  SignOut(this.repository);

  Future<Either<Failure, void>> call() async {
    try {
      await repository.signOut();
      return Right(null);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
