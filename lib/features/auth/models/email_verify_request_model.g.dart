// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_verify_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailVerifyRequestModel _$EmailVerifyRequestModelFromJson(
        Map<String, dynamic> json) =>
    EmailVerifyRequestModel(
      email: json['email'] as String,
      code: json['code'] as String,
    );

Map<String, dynamic> _$EmailVerifyRequestModelToJson(
        EmailVerifyRequestModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'code': instance.code,
    };
