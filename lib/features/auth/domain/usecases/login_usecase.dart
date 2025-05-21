// lib/features/auth/domain/usecases/login_usecase.dart
import 'package:primero/features/auth/data/models/login_request_model.dart';
import 'package:primero/features/auth/domain/entities/auth_response_entity.dart';
import 'package:primero/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<AuthResponseEntity> call({
    required String email,
    required String password,
  }) async {
    final deviceUuid = await repository.getDeviceUuid();
    if (deviceUuid == null) {
      throw Exception('기기 ID를 가져올 수 없습니다. 앱을 재시작하거나 지원팀에 문의하세요.');
    }
    return await repository.login(
      LoginRequestModel(
        email: email,
        password: password,
        deviceUuid: deviceUuid,
      ),
    );
  }
}
