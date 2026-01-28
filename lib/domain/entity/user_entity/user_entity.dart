import 'package:equatable/equatable.dart';

class LoginUserEntity extends Equatable {
  final String email;
  final String password;

  const LoginUserEntity({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [
    email,
    password,
  ];
}
