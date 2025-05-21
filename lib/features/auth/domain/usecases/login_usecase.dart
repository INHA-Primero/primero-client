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
    // UseCase에서 직접 deviceUuid를 가져와서 Repository에 전달
    final deviceUuid = await repository.getDeviceUuid();
    if (deviceUuid == null) {
      throw Exception('기기 ID를 생성하거나 가져올 수 없습니다.');
    }

    final requestModel = LoginRequestModel(
      // 모델 생성 시 deviceUuid 제외
      email: email,
      password: password,
    );
    return await repository.login(
      requestModel,
      deviceUuid,
    ); // deviceUuid를 별도 전달
  }
}
