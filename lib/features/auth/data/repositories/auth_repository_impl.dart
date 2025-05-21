// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:primero/core/services/device_uuid_service.dart'; // DeviceUuidService 임포트
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
  final DeviceUuidService _deviceUuidService; // DeviceUuidService 주입

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required DeviceUuidService deviceUuidService, // 생성자에서 주입
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
  Future<AuthResponseEntity> signup(SignupRequestModel requestModel) async {
    final AuthResponseModel responseModel = await _remoteDataSource.signup(
      requestModel,
    );
    // 회원가입 성공 시 토큰 저장 (API 응답에 토큰이 포함되어 있다고 가정)
    if (responseModel.accessToken != null) {
      await _localDataSource.saveTokens(
        accessToken: responseModel.accessToken!,
        refreshToken: responseModel.refreshToken,
      );
    }
    return responseModel.toEntity();
  }

  @override
  Future<AuthResponseEntity> login(LoginRequestModel requestModel) async {
    final AuthResponseModel responseModel = await _remoteDataSource.login(
      requestModel,
    );
    // 로그인 성공 시 토큰 저장
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
    // TODO: 서버 측 로그아웃 API가 있다면 호출 (_remoteDataSource.logout())
    // 현재는 로컬 토큰만 삭제
    await _localDataSource.deleteTokens();
  }

  @override
  Future<AuthResponseEntity?> getAuthStatus() async {
    // 로컬에 저장된 액세스 토큰을 확인
    final accessToken = await _localDataSource.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      return null; // 토큰이 없으면 비인증 상태
    }
    // TODO: 실제로는 토큰 유효성 검사 API를 호출하거나,
    //       저장된 사용자 정보를 반환하는 로직이 필요할 수 있습니다.
    //       여기서는 임시로 토큰이 있으면 인증된 것으로 간주하고,
    //       로그인 시 저장했던 사용자 정보를 반환한다고 가정합니다.
    //       (또는 /users/me 같은 API로 현재 사용자 정보를 다시 가져올 수 있음)
    //       이 예제에서는 AuthResponseEntity를 직접 구성하지 않고 null을 반환하거나,
    //       로그인/회원가입 시 저장한 사용자 정보를 로컬에서 가져와 반환해야 합니다.
    //       간단하게는, 토큰 존재 여부만으로 판단 후, 실제 사용자 정보는 Profile 기능에서 가져오도록 할 수 있습니다.

    // 임시: 토큰이 있다면, 사용자 정보를 다시 가져오는 API가 없으므로,
    // 로그인/회원가입 시 저장된 최소한의 정보(예: userId)를 반환하거나,
    // AuthResponseEntity의 일부 필드만 채워서 반환할 수 있습니다.
    // 여기서는 토큰이 있다는 사실만으로 인증 상태를 나타내고,
    // 상세 사용자 정보는 ProfileNotifier에서 가져온다고 가정합니다.
    // 실제 앱에서는 이 부분을 더 견고하게 만들어야 합니다.
    // 예를 들어, 로컬에 userId라도 저장해두었다가 반환할 수 있습니다.
    // final storedUserId = await _localDataSource.getUserId(); // 예시
    // if (storedUserId != null) {
    //   return AuthResponseEntity(userId: storedUserId, barcodeUrl: '', accessToken: accessToken);
    // }
    return AuthResponseEntity(
      userId: 0,
      barcodeUrl: '',
      accessToken: accessToken,
    ); // 임시 userId
  }

  @override
  Future<String?> getDeviceUuid() async {
    // DeviceUuidService를 통해 UUID를 가져옵니다.
    return await _deviceUuidService.getOrCreateDeviceUuid();
  }
}
