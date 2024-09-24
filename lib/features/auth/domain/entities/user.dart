import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String profileImageUrl;

  UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.profileImageUrl,
  });

  @override
  List<Object?> get props => [id, email, name, profileImageUrl];
}
