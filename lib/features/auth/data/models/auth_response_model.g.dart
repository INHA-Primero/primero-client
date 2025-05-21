// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponseModel _$AuthResponseModelFromJson(Map<String, dynamic> json) =>
    AuthResponseModel(
      userId: (json['user_id'] as num).toInt(),
      nickname: json['nickname'] as String?,
      role: json['role'] as String?,
      totalPoint: (json['total_point'] as num?)?.toInt(),
      barcodeUrl: json['barcode_url'] as String,
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
    );

Map<String, dynamic> _$AuthResponseModelToJson(AuthResponseModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'nickname': instance.nickname,
      'role': instance.role,
      'total_point': instance.totalPoint,
      'barcode_url': instance.barcodeUrl,
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
    };
