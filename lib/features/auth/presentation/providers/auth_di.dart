// lib/features/auth/presentation/providers/auth_di.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:primero/core/network/auth_intercepter.dart'; // AuthInterceptor 경로
import 'package:primero/core/services/device_uuid_service.dart'; // DeviceUuidService 경로
import 'package:primero/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:primero/features/auth/data/sources/local/auth_local_data_source.dart';
import 'package:primero/features/auth/data/sources/remote/auth_remote_data_source.dart';
import 'package:primero/features/auth/domain/repositories/auth_repository.dart';
import 'package:primero/features/auth/domain/usecases/get_auth_status_usecase.dart';
import 'package:primero/features/auth/domain/usecases/login_usecase.dart';
import 'package:primero/features/auth/domain/usecases/logout_usecase.dart';
import 'package:primero/features/auth/domain/usecases/request_email_verification_usecase.dart';
import 'package:primero/features/auth/domain/usecases/resend_email_verification_usecase.dart';
import 'package:primero/features/auth/domain/usecases/signup_usecase.dart';
import 'package:primero/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:primero/features/auth/presentation/providers/auth_notifier.dart';
import 'package:primero/features/auth/presentation/providers/auth_state.dart';
import 'package:uuid/uuid.dart';

// --- Core Services ---
final flutterSecureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);
final uuidProvider = Provider<Uuid>((ref) => const Uuid());

final deviceUuidServiceProvider = Provider<DeviceUuidService>((ref) {
  return DeviceUuidService(
    secureStorage: ref.watch(flutterSecureStorageProvider),
    uuid: ref.watch(uuidProvider),
  );
});

// --- Dio Instance for Auth ---
// 기존 profileFeatureDioProvider와 별도로 인증용 Dio 인스턴스를 만들거나,
// API 서버가 동일하다면 기존 것을 같이 사용할 수 있습니다.
// 여기서는 별도로 만들고 AuthInterceptor를 적용하는 예시를 보여줍니다.
final authDioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  // dio.options.baseUrl = "YOUR_AUTH_API_BASE_URL"; // 필요시 기본 URL 설정
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
      requestHeader: true,
    ),
  );

  // AuthInterceptor 추가 (AuthLocalDataSource에 의존)
  // 순환 의존성을 피하기 위해 ref.read 대신 ref.watch 사용 시 주의 필요.
  // AuthLocalDataSource가 먼저 생성되도록 Provider 의존성 순서 조정 또는
  // 인터셉터 내부에서 Provider를 read 하는 방식 고려.
  // 여기서는 AuthLocalDataSourceProvider를 먼저 정의하고 watch 하도록 함.
  dio.interceptors.add(AuthInterceptor(ref.watch(authLocalDataSourceProvider)));
  return dio;
});

// --- Auth Data Sources ---
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(
    secureStorage: ref.watch(flutterSecureStorageProvider),
  );
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(
    dio: ref.watch(authDioProvider),
  ); // 인증용 Dio 사용
});

// --- Auth Repository ---
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
    deviceUuidService: ref.watch(
      deviceUuidServiceProvider,
    ), // DeviceUuidService 주입
  );
});

// --- Auth UseCases ---
final requestEmailVerificationUseCaseProvider =
    Provider<RequestEmailVerificationUseCase>((ref) {
      return RequestEmailVerificationUseCase(ref.watch(authRepositoryProvider));
    });

final resendEmailVerificationUseCaseProvider =
    Provider<ResendEmailVerificationUseCase>((ref) {
      return ResendEmailVerificationUseCase(ref.watch(authRepositoryProvider));
    });

final verifyEmailUseCaseProvider = Provider<VerifyEmailUseCase>((ref) {
  return VerifyEmailUseCase(ref.watch(authRepositoryProvider));
});

final signupUseCaseProvider = Provider<SignupUseCase>((ref) {
  return SignupUseCase(ref.watch(authRepositoryProvider));
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

final getAuthStatusUseCaseProvider = Provider<GetAuthStatusUseCase>((ref) {
  return GetAuthStatusUseCase(ref.watch(authRepositoryProvider));
});

// --- Auth State Notifier ---
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier(
    loginUseCase: ref.watch(loginUseCaseProvider),
    signupUseCase: ref.watch(signupUseCaseProvider),
    logoutUseCase: ref.watch(logoutUseCaseProvider),
    getAuthStatusUseCase: ref.watch(getAuthStatusUseCaseProvider),
    requestEmailVerificationUseCase: ref.watch(
      requestEmailVerificationUseCaseProvider,
    ),
    resendEmailVerificationUseCase: ref.watch(
      resendEmailVerificationUseCaseProvider,
    ),
    verifyEmailUseCase: ref.watch(verifyEmailUseCaseProvider),
    deviceUuidService: ref.watch(
      deviceUuidServiceProvider,
    ), // DeviceUuidService 주입
  );
});
