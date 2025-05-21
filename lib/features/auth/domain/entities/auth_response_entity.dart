// lib/features/auth/domain/entities/auth_response_entity.dart
import 'package:equatable/equatable.dart';

// API 응답을 앱 내부에서 사용하기 위한 도메인 객체
// AuthResponseModel의 toEntity() 메서드를 통해 생성됨
class AuthResponseEntity extends Equatable {
  final int userId;
  final String? nickname;
  final String? role;
  final int? totalPoint;
  final String barcodeUrl;
  final String? accessToken; // API 응답에 토큰이 포함되어 있다고 가정
  final String? refreshToken; // API 응답에 토큰이 포함되어 있다고 가정

  const AuthResponseEntity({
    required this.userId,
    this.nickname,
    this.role,
    this.totalPoint,
    required this.barcodeUrl,
    this.accessToken,
    this.refreshToken,
  });

  @override
  List<Object?> get props => [
    userId,
    nickname,
    role,
    totalPoint,
    barcodeUrl,
    accessToken,
    refreshToken,
  ];
}

// 필요하다면 UserEntity를 별도로 정의하거나, 기존 UserProfileEntity를 활용/확장할 수 있습니다.
// 예: lib/features/auth/domain/entities/user_entity.dart
// import 'package:equatable/equatable.dart';
//
// class UserEntity extends Equatable {
//   final int id;
//   final String email;
//   final String name;
//   // ... 기타 필요한 사용자 정보 필드
//
//   const UserEntity({required this.id, required this.email, required this.name});
//
//   @override
//   List<Object?> get props => [id, email, name];
// }
