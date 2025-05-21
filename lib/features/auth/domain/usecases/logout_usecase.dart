// lib/features/auth/domain/usecases/logout_usecase.dart
import 'package:primero/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;
  LogoutUseCase(this.repository);

  Future<void> call() async {
    await repository.logout();
  }
}
