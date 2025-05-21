// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:primero/core/services/device_uuid_service.dart';
import 'package:primero/features/auth/data/models/auth_response_model.dart';
import 'package:primero/features/auth/data/models/email_verification_confirm_request_model.dart';
import 'package:primero/features/auth/data/models/email_verification_request_model.dart';
import 'package:primero/features/auth/data/models/login_request_model.dart';
import 'package:primero/features/auth/data/models/signup_request_model.dart';
import 'package:primero/features/auth/data/sources/local/auth_local_data_source.dart';
import 'package:primero/features/auth/data/sources/remote/auth_remote_data_source.dart';
import 'package:primero/features/auth/domain/entities/auth_response_entity.dart';
import 'package:primero/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final DeviceUuidService _deviceUuidService;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required DeviceUuidService deviceUuidService,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _deviceUuidService = deviceUuidService;

  @override
  Future<void> requestEmailVerification(
    EmailVerificationRequestModel requestModel,
  ) async {
    await _remoteDataSource.requestEmailVerification(requestModel);
  }

  @override
  Future<void> resendEmailVerification(
    EmailVerificationRequestModel requestModel,
  ) async {
    await _remoteDataSource.resendEmailVerification(requestModel);
  }

  @override
  Future<void> verifyEmailCode(
    EmailVerificationConfirmRequestModel requestModel,
  ) async {
    await _remoteDataSource.verifyEmailCode(requestModel);
  }

  @override
  Future<AuthResponseEntity> signup(
    SignupRequestModel requestModel,
    String deviceUuid,
  ) async {
    // deviceUuid를 remoteDataSource.signup에 직접 전달
    final AuthResponseModel responseModel = await _remoteDataSource.signup(
      requestModel,
      deviceUuid,
    );
    if (responseModel.accessToken != null) {
      await _localDataSource.saveTokens(
        accessToken: responseModel.accessToken!,
        refreshToken: responseModel.refreshToken,
      );
    }
    return responseModel.toEntity();
  }

  @override
  Future<AuthResponseEntity> login(
    LoginRequestModel requestModel,
    String deviceUuid,
  ) async {
    // deviceUuid를 remoteDataSource.login에 직접 전달
    final AuthResponseModel responseModel = await _remoteDataSource.login(
      requestModel,
      deviceUuid,
    );
    if (responseModel.accessToken != null) {
      await _localDataSource.saveTokens(
        accessToken: responseModel.accessToken!,
        refreshToken: responseModel.refreshToken,
      );
    }
    return responseModel.toEntity();
  }

  @override
  Future<void> logout() async {
    // TODO: 서버 측 로그아웃 API 호출
    await _localDataSource.deleteTokens();
  }

  @override
  Future<AuthResponseEntity?> getAuthStatus() async {
    final accessToken = await _localDataSource.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      return null;
    }
    // TODO: 실제로는 토큰 유효성 검사 또는 저장된 사용자 정보 반환 로직 필요
    // 임시로, 토큰이 있으면 최소한의 정보로 AuthResponseEntity 반환 (백엔드와 협의 필요)
    // 예를 들어, 로그인/회원가입 시 userId를 로컬에 저장했다가 사용할 수 있음.
    // final userId = await _localDataSource.getUserId(); // 가상의 메서드
    // return AuthResponseEntity(userId: userId ?? 0, barcodeUrl: '', accessToken: accessToken);
    print(
      "AuthRepositoryImpl: getAuthStatus - Found access token. Assuming authenticated for now.",
    );
    return AuthResponseEntity(
      userId: 0,
      barcodeUrl: 'temp_barcode',
      accessToken: accessToken,
    ); // 임시 userId 및 barcodeUrl
  }

  @override
  Future<String?> getDeviceUuid() async {
    return await _deviceUuidService.getOrCreateDeviceUuid();
  }
}
