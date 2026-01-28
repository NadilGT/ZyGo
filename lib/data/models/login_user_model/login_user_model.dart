import 'package:json_annotation/json_annotation.dart';
import 'package:zygo/domain/entity/user_entity/user_entity.dart';

part 'login_user_model.g.dart';

@JsonSerializable()
class LoginUserModel extends LoginUserEntity{
  const LoginUserModel({required super.email, required super.password});

  factory LoginUserModel.fromJson(Map<String, dynamic> json) => _$LoginUserModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoginUserModelToJson(this);
}