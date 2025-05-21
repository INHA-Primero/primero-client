import 'package:primero/features/auth/data/models/email_verification_confirm_request_model.dart';
import 'package:primero/features/auth/domain/repositories/auth_repository.dart';

class VerifyEmailUseCase {
  final AuthRepository repository;
  VerifyEmailUseCase(this.repository);

  Future<void> call({
    required String email,
    required String verificationCode,
  }) async {
    if (verificationCode.isEmpty) {
      // 예시: 인증번호 비어있는지 확인
      throw ArgumentError('인증번호를 입력해주세요.');
    }
    await repository.verifyEmailCode(
      EmailVerificationConfirmRequestModel(
        email: email,
        verificationCode: verificationCode,
      ),
    );
  }
}
