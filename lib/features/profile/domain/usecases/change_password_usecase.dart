// --- ChangePasswordUseCase 추가 ---
// lib/features/profile/domain/usecases/change_password_usecase.dart (새 파일)

import 'package:primero/features/profile/domain/entities/user_profile_entity.dart';
import 'package:primero/features/profile/domain/repositories/profile_repository.dart';

class ChangePasswordParams {
  final String currentPassword;
  final String newPassword;

  ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });
}

class ChangePasswordUseCase {
  final ProfileRepository repository;
  ChangePasswordUseCase(this.repository);

  Future<void> call(ChangePasswordParams params) async {
    // 여기서 새 비밀번호의 유효성 검사 (예: 길이, 복잡도)를 추가할 수 있습니다.
    // (프론트 1차 검증, 서버 최종 검증)
    if (params.newPassword.length < 6) {
      // 예시: 최소 6자
      throw Exception("새 비밀번호는 6자 이상이어야 합니다.");
    }
    // 현재 비밀번호와 새 비밀번호가 같은 경우 등 추가 검증 가능

    try {
      await repository.changePassword(
        currentPassword: params.currentPassword,
        newPassword: params.newPassword,
      );
    } catch (e) {
      print('Error in ChangePasswordUseCase: $e');
      // 서버에서 오는 특정 에러 메시지에 따라 분기 처리 가능
      if (e.toString().contains('Current password does not match')) {
        throw Exception('현재 비밀번호가 일치하지 않습니다.');
      }
      throw Exception('비밀번호 변경에 실패했습니다. (UseCase)');
    }
  }
}
