// lib/features/profile/domain/usecases/get_user_profile_usecase.dart

import 'package:primero/features/profile/domain/entities/user_profile_entity.dart';
import 'package:primero/features/profile/domain/repositories/profile_repository.dart';

/// 사용자 프로필 정보를 가져오는 유스케이스입니다.
/// 이 클래스는 특정 사용자의 프로필을 조회하는 단일 기능을 수행합니다.
class GetUserProfileUseCase {
  // 이 유스케이스는 ProfileRepository 인터페이스에 의존합니다.
  // 실제 구현체(ProfileRepositoryImpl)는 외부에서 주입받습니다 (의존성 주입).
  final ProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  /// 유스케이스를 실행합니다.
  ///
  /// 현재 로그인된 사용자의 프로필 정보를 가져옵니다.
  /// 성공 시 [UserProfileEntity]를 반환하고, 실패 시 예외를 발생시킬 수 있습니다.
  /// (Repository의 getUserProfile 메서드가 userId를 요구하지 않는다고 가정)
  Future<UserProfileEntity> call() async {
    // ProfileRepository의 getUserProfile 메서드를 호출하여 데이터를 가져옵니다.
    // 이 유스케이스 자체에는 복잡한 비즈니스 로직이 없을 수도 있지만,
    // 필요하다면 여기서 데이터를 추가로 가공하거나, 여러 Repository를 조합하는 등의 로직이 들어갈 수 있습니다.
    try {
      return await repository.getUserProfile();
    } catch (e) {
      // 유스케이스 레벨에서 특정 에러를 잡아서 다른 형태로 변환하거나,
      // 로깅 등의 추가 작업을 수행할 수 있습니다.
      // 이 예제에서는 Repository에서 발생한 예외를 그대로 다시 던집니다.
      print('Error in GetUserProfileUseCase: $e');
      throw Exception('프로필 정보를 가져오는 데 실패했습니다. (UseCase)');
    }
  }
}
