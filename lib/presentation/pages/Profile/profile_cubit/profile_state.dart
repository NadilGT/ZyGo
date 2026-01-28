import 'package:zygo/domain/entity/profile_response_entity/profile_response_entity.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState{}

class ProfileLoading extends ProfileState{}

class ProfileSuccess extends ProfileState{
  final ProfileResponseEntity user;
  ProfileSuccess(this.user);
}

class ProfileFailure extends ProfileState{
  final String error;
  ProfileFailure(this.error);
}