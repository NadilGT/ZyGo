import 'package:equatable/equatable.dart';

class ProfileResponseEntity extends Equatable{
  final String email;
  final String name;
  final String user_id;

  const ProfileResponseEntity({
    required this.email,
    required this.name,
    required this.user_id,
  });

  @override
  List<Object?> get props => [
    email,
    name,
    user_id
  ];
  
}