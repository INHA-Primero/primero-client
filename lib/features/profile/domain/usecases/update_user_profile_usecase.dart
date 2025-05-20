// lib/features/profile/domain/usecases/update_user_profile_usecase.dart
// (이름(name) 파라미터 제거)
import 'package:primero/features/profile/domain/entities/user_profile_entity.dart';
import 'package:primero/features/profile/domain/repositories/profile_repository.dart';

class UpdateUserProfileParams {
  final String? nickname;
  final String? profileImageUrl;

  UpdateUserProfileParams({this.nickname, this.profileImageUrl});
}

class UpdateUserProfileUseCase {
  final ProfileRepository repository;
  UpdateUserProfileUseCase(this.repository);

  Future<UserProfileEntity> call(UpdateUserProfileParams params) async {
    if (params.nickname == null && params.profileImageUrl == null) {
      // 아무것도 변경하지 않는 경우, 현재 프로필 정보를 다시 가져와 반환하거나 예외 처리.
      // 이 예제에서는 Repository가 빈 요청을 어떻게 처리하는지에 따라 달라지지만,
      // UseCase 레벨에서 "변경 사항 없음"을 명시적으로 처리하는 것이 좋을 수 있습니다.
      // 예를 들어, 현재 프로필 정보를 다시 반환하거나, 특정 상태를 나타내는 값을 반환.
      // 여기서는 Repository 호출로 넘깁니다.
    }
    try {
      return await repository.updateUserProfile(
        nickname: params.nickname,
        profileImageUrl: params.profileImageUrl,
      );
    } catch (e) {
      print('Error in UpdateUserProfileUseCase: $e');
      if (e.toString().contains('Nickname already in use')) {
        // 예시 에러 메시지 확인
        throw Exception('이미 사용 중인 닉네임(나무 이름)입니다. 다른 이름을 입력해주세요.');
      }
      throw Exception('프로필 업데이트에 실패했습니다. (UseCase)');
    }
  }
}
