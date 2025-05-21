// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_verification_confirm_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailVerificationConfirmRequestModel
_$EmailVerificationConfirmRequestModelFromJson(Map<String, dynamic> json) =>
    EmailVerificationConfirmRequestModel(
      email: json['email'] as String,
      verificationCode: json['verification_code'] as String,
    );

Map<String, dynamic> _$EmailVerificationConfirmRequestModelToJson(
  EmailVerificationConfirmRequestModel instance,
) => <String, dynamic>{
  'email': instance.email,
  'verification_code': instance.verificationCode,
};
