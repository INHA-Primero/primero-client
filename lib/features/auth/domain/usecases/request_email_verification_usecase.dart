import 'package:primero/features/auth/data/models/email_verification_request_model.dart';
import 'package:primero/features/auth/domain/repositories/auth_repository.dart';

class RequestEmailVerificationUseCase {
  final AuthRepository repository;
  RequestEmailVerificationUseCase(this.repository);

  Future<void> call(String email) async {
    // 이메일 형식 유효성 검사 등 간단한 로직 추가 가능
    if (email.isEmpty || !email.contains('@')) {
      // 매우 기본적인 검사
      throw ArgumentError('올바른 이메일 형식이 아닙니다.');
    }
    await repository.requestEmailVerification(
      EmailVerificationRequestModel(email: email),
    );
  }
}
