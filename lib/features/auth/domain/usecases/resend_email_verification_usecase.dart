import 'package:primero/features/auth/data/models/email_verification_request_model.dart';
import 'package:primero/features/auth/domain/repositories/auth_repository.dart';

class ResendEmailVerificationUseCase {
  final AuthRepository repository;
  ResendEmailVerificationUseCase(this.repository);

  Future<void> call(String email) async {
    if (email.isEmpty || !email.contains('@')) {
      throw ArgumentError('올바른 이메일 형식이 아닙니다.');
    }
    await repository.resendEmailVerification(
      EmailVerificationRequestModel(email: email),
    );
  }
}
