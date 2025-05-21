// lib/features/auth/domain/usecases/signup_usecase.dart
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
  }) async {
    if (password.length < 6) {
      throw ArgumentError('비밀번호는 6자 이상이어야 합니다.');
    }
    // UseCase에서 직접 deviceUuid를 가져와서 Repository에 전달
    final deviceUuid = await repository.getDeviceUuid();
    if (deviceUuid == null) {
      // 이 경우는 거의 발생하지 않아야 함 (getOrCreateDeviceUuid 사용 시)
      throw Exception('기기 ID를 생성하거나 가져올 수 없습니다. 앱을 재시작하거나 관리자에게 문의하세요.');
    }

    final requestModel = SignupRequestModel(
      // 모델 생성 시 deviceUuid 제외
      email: email,
      password: password,
      name: name,
      studentNumber: studentNumber,
      nickname: nickname,
    );
    return await repository.signup(
      requestModel,
      deviceUuid,
    ); // deviceUuid를 별도 전달
  }
}
