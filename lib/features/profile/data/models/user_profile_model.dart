// lib/features/profile/data/models/user_profile_model.dart

import 'package:json_annotation/json_annotation.dart';
import 'package:primero/features/profile/domain/entities/user_profile_entity.dart'; // Entity 임포트

// 이 줄은 build_runner를 실행하여 코드를 생성하라는 의미입니다.
// 파일명은 현재 파일명과 동일하게 맞춰줍니다. (예: user_profile_model.g.dart)
part 'user_profile_model.g.dart';

/// API 서버와 직접 통신하여 주고받는 사용자 프로필 데이터의 구조를 나타내는 모델 클래스입니다.
/// json_serializable 패키지를 사용하여 fromJson/toJson 메서드를 자동 생성합니다.
/// 필드명은 API JSON의 키 이름(카멜 케이스)과 동일하게 작성합니다.
@JsonSerializable() // 직렬화/역직렬화 대상 클래스임을 명시
class UserProfileModel {
  final int userId;
  final String email;
  final String name;
  final String studentNumber;
  final String nickname; // '나무 이름'으로도 사용
  final String? profileImageUrl; // null일 수 있는 필드는 타입 뒤에 ?를 붙입니다.
  final int totalPoint;

  const UserProfileModel({
    required this.userId,
    required this.email,
    required this.name,
    required this.studentNumber,
    required this.nickname,
    this.profileImageUrl,
    required this.totalPoint,
  });

  /// JSON 맵으로부터 UserProfileModel 인스턴스를 생성하는 팩토리 생성자입니다.
  /// `_$UserProfileModelFromJson` 함수는 build_runner에 의해 자동 생성됩니다.
  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  /// UserProfileModel 인스턴스를 JSON 맵으로 변환하는 메서드입니다.
  /// `_$UserProfileModelToJson` 함수는 build_runner에 의해 자동 생성됩니다.
  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);

  /// UserProfileModel을 UserProfileEntity로 변환하는 메서드입니다.
  /// 도메인 계층으로 데이터를 전달할 때 사용됩니다.
  UserProfileEntity toEntity() {
    return UserProfileEntity(
      userId: userId,
      email: email,
      name: name,
      studentNumber: studentNumber,
      nickname: nickname,
      profileImageUrl: profileImageUrl,
      totalPoint: totalPoint,
    );
  }
}
