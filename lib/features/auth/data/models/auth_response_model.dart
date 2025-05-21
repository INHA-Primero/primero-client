// lib/features/auth/data/models/auth_response_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:primero/features/auth/domain/entities/auth_response_entity.dart';

part 'auth_response_model.g.dart';

// API 응답에 따라 필드 추가/수정 필요 (특히 토큰 관련)
@JsonSerializable(fieldRename: FieldRename.snake)
class AuthResponseModel {
  final int userId;
  final String? nickname; // 로그인 응답에는 있지만 회원가입 응답에는 없을 수 있음
  final String? role; // 로그인 응답에만 있음
  final int? totalPoint; // 로그인 응답에만 있음
  final String barcodeUrl;
  // API 명세에는 없지만, 인증 시스템에 필수적인 토큰 필드 (백엔드와 협의하여 추가 가정)
  final String? accessToken;
  final String? refreshToken;

  AuthResponseModel({
    required this.userId,
    this.nickname,
    this.role,
    this.totalPoint,
    required this.barcodeUrl,
    this.accessToken,
    this.refreshToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);

  AuthResponseEntity toEntity() {
    return AuthResponseEntity(
      userId: userId,
      nickname: nickname,
      role: role,
      totalPoint: totalPoint,
      barcodeUrl: barcodeUrl,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
