import 'package:equatable/equatable.dart';

class LoginResponseEntity extends Equatable {
  final String token;
  final UserEntity user;

  const LoginResponseEntity({
    required this.token,
    required this.user,
  });

  @override
  List<Object?> get props => [
    token,
    user,
  ];
}

class UserEntity extends Equatable {
  final String email;
  final String id;
  final String name;

  const UserEntity({
    required this.email,
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [
    email,
    id,
    name,
  ];
}
