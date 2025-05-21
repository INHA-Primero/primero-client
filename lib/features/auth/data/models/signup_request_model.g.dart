// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignupRequestModel _$SignupRequestModelFromJson(Map<String, dynamic> json) =>
    SignupRequestModel(
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      studentNumber: json['student_number'] as String,
      nickname: json['nickname'] as String,
      deviceUuid: json['device_uuid'] as String,
    );

Map<String, dynamic> _$SignupRequestModelToJson(SignupRequestModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'name': instance.name,
      'student_number': instance.studentNumber,
      'nickname': instance.nickname,
      'device_uuid': instance.deviceUuid,
    };
