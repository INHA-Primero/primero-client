// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_modify_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModifyRequestModel _$UserModifyRequestModelFromJson(
        Map<String, dynamic> json) =>
    UserModifyRequestModel(
      treeName: json['treeName'] as String,
      password: json['password'] as String?,
      profileImgPath: json['profileImgPath'] as String?,
    );

Map<String, dynamic> _$UserModifyRequestModelToJson(
        UserModifyRequestModel instance) =>
    <String, dynamic>{
      'treeName': instance.treeName,
      'password': instance.password,
      'profileImgPath': instance.profileImgPath,
    };
