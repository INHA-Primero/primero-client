// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    UserProfileModel(
      userId: (json['userId'] as num).toInt(),
      email: json['email'] as String,
      name: json['name'] as String,
      studentNumber: (json['studentNumber'] as num).toInt(),
      treeName: json['treeName'] as String,
      profileImgPath: json['profileImgPath'] as String?,
      totalPoint: (json['totalPoint'] as num).toInt(),
    );

Map<String, dynamic> _$UserProfileModelToJson(UserProfileModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'name': instance.name,
      'studentNumber': instance.studentNumber,
      'treeName': instance.treeName,
      'profileImgPath': instance.profileImgPath,
      'totalPoint': instance.totalPoint,
    };
