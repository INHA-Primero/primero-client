// lib/features/profile/domain/entities/user_profile_entity.dart
// (이전 답변의 UserProfileEntity 코드와 동일 - 변경 없음)
import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final int userId;
  final String email;
  final String name;
  final String studentNumber;
  final String nickname; // '나무 이름'으로도 사용
  final String? profileImageUrl;
  final int totalPoint;

  const UserProfileEntity({
    required this.userId,
    required this.email,
    required this.name,
    required this.studentNumber,
    required this.nickname,
    this.profileImageUrl,
    required this.totalPoint,
  });

  @override
  List<Object?> get props => [
    userId,
    email,
    name,
    studentNumber,
    nickname,
    profileImageUrl,
    totalPoint,
  ];

  // copyWith 메서드는 필요에 따라 직접 구현하거나,
  // freezed 같은 패키지를 사용하면 자동으로 생성됩니다.
  UserProfileEntity copyWith({
    int? userId,
    String? email,
    String? name,
    String? studentNumber,
    String? nickname,
    // profileImageUrl을 명시적으로 null로 만들거나 값을 설정하기 위한 처리
    ValueGetter<String?>? profileImageUrl,
    int? totalPoint,
  }) {
    return UserProfileEntity(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      studentNumber: studentNumber ?? this.studentNumber,
      nickname: nickname ?? this.nickname,
      profileImageUrl:
          profileImageUrl != null ? profileImageUrl() : this.profileImageUrl,
      totalPoint: totalPoint ?? this.totalPoint,
    );
  }
}

// ValueGetter를 사용하여 nullable 필드의 명시적인 null 업데이트를 copyWith에서 지원
typedef ValueGetter<T> = T Function();
