// lib/features/auth/domain/usecases/get_auth_status_usecase.dart
import 'package:primero/features/auth/domain/entities/auth_response_entity.dart';
import 'package:primero/features/auth/domain/repositories/auth_repository.dart';

class GetAuthStatusUseCase {
  final AuthRepository repository;
  GetAuthStatusUseCase(this.repository);

  Future<AuthResponseEntity?> call() async {
    // Repository를 통해 현재 인증 상태 (예: 저장된 유효한 토큰 유무, 사용자 정보)를 가져옴
    return await repository.getAuthStatus();
  }
}
