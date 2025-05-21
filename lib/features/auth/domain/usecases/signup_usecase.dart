import 'package:primero/features/auth/data/models/signup_request_model.dart';
import 'package:primero/features/auth/domain/entities/auth_response_entity.dart';
import 'package:primero/features/auth/domain/repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;
  SignupUseCase(this.repository);

  Future<AuthResponseEntity> call({
    required String email,
    required String password,
    required String name,
    required String studentNumber,
    required String nickname,
    // deviceUuid는 RepositoryImpl에서 DeviceUuidService를 통해 가져오도록 수정했으므로,
    // UseCase 파라미터에서는 제외하거나, RepositoryImpl에서 처리하지 않는다면 여기서 주입해야 함.
    // 현재는 RepositoryImpl에서 처리하는 것으로 가정.
  }) async {
    // 비밀번호 유효성 검사 등 추가 로직 가능
    if (password.length < 6) {
      // 예시: 최소 6자
      throw ArgumentError('비밀번호는 6자 이상이어야 합니다.');
    }
    final deviceUuid = await repository.getDeviceUuid();
    if (deviceUuid == null) {
      throw Exception('기기 ID를 가져올 수 없습니다. 앱을 재시작하거나 지원팀에 문의하세요.');
    }

    return await repository.signup(
      SignupRequestModel(
        email: email,
        password: password,
        name: name,
        studentNumber: studentNumber,
        nickname: nickname,
        deviceUuid: deviceUuid,
      ),
    );
  }
}
