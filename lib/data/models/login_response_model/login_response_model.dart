import 'package:json_annotation/json_annotation.dart';
import 'package:zygo/domain/entity/login_response_entity/login_response_entity.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel extends LoginResponseEntity {
  @override
  final UserModel user;

  const LoginResponseModel({
    required super.token,
    required this.user,
  }) : super(user: user);

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}

@JsonSerializable()
class UserModel extends UserEntity {
  const UserModel({
    required super.email,
    required super.id,
    required super.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
