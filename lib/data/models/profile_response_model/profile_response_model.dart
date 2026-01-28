import 'package:json_annotation/json_annotation.dart';
import 'package:zygo/domain/entity/profile_response_entity/profile_response_entity.dart';

part 'profile_response_model.g.dart';

@JsonSerializable()
class ProfileResponseModel extends ProfileResponseEntity {
  const ProfileResponseModel({
    required super.email,
    required super.name,
    required super.user_id,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) => 
      _$ProfileResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileResponseModelToJson(this);
}
