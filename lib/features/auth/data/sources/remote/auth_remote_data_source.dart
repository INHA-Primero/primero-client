// lib/features/auth/data/sources/remote/auth_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:primero/features/auth/data/models/auth_response_model.dart';
import 'package:primero/features/auth/data/models/email_verification_confirm_request_model.dart';
import 'package:primero/features/auth/data/models/email_verification_request_model.dart';
import 'package:primero/features/auth/data/models/login_request_model.dart';
import 'package:primero/features/auth/data/models/signup_request_model.dart';

// TODO: 실제 API 서버의 기본 URL로 변경해야 합니다.
const String _authApiBaseUrl =
    "https://88a37a13-b991-4107-9315-5afcefdf6af3.mock.pstmn.io/auth"; // 인증 관련 기본 경로 예시
const String _userApiBaseUrl =
    "https://88a37a13-b991-4107-9315-5afcefdf6af3.mock.pstmn.io"; // 사용자 관련 기본 경로 예시 (signup)

abstract class AuthRemoteDataSource {
  Future<void> requestEmailVerification(
    EmailVerificationRequestModel requestModel,
  );
  Future<void> resendEmailVerification(
    EmailVerificationRequestModel requestModel,
  );
  Future<void> verifyEmailCode(
    EmailVerificationConfirmRequestModel requestModel,
  );
  Future<AuthResponseModel> signup(SignupRequestModel requestModel);
  Future<AuthResponseModel> login(LoginRequestModel requestModel);
  // Future<void> logout(); // 서버 측 토큰 무효화 API가 있다면 추가
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  /// API 호출을 위한 공통 헬퍼 메서드 (에러 처리 포함)
  Future<T> _handleApiCall<T>(
    Future<Response<dynamic>> Function() apiCall,
    T Function(dynamic data) onSuccess, {
    String? operationName, // 로깅이나 에러 메시지에 사용할 작업 이름
  }) async {
    final opName = operationName ?? 'API 작업';
    try {
      final response = await apiCall();
      // API 명세에 따라 성공 상태 코드가 다를 수 있음 (200, 201 등)
      if (response.statusCode == 200 || response.statusCode == 201) {
        // 성공 응답 본문이 없는 경우 (예: void 반환 API)도 고려
        if (response.data == null && null is T) {
          return null as T;
        }
        return onSuccess(response.data);
      } else {
        // 서버에서 정의된 에러 메시지가 있다면 그것을 사용
        final errorMessage =
            response.data?['message'] ??
            '$opName 실패: 상태 코드 ${response.statusCode}';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
        );
      }
    } on DioException catch (e) {
      print(
        'DioException in $opName: ${e.message}, Response: ${e.response?.data}',
      );
      final serverMessage =
          e.response?.data?['message'] ?? e.response?.data?['error'];
      final displayMessage = serverMessage ?? e.message ?? '$opName 중 서버 통신 오류';
      throw Exception(displayMessage);
    } catch (e) {
      print('Unexpected error in $opName: $e');
      throw Exception('$opName 중 알 수 없는 오류가 발생했습니다.');
    }
  }

  @override
  Future<void> requestEmailVerification(
    EmailVerificationRequestModel requestModel,
  ) async {
    return _handleApiCall<void>(
      () => _dio.post('$_authApiBaseUrl/email', data: requestModel.toJson()),
      (_) {}, // 성공 시 반환값 없음 (void)
      operationName: '이메일 인증 요청',
    );
  }

  @override
  Future<void> resendEmailVerification(
    EmailVerificationRequestModel requestModel,
  ) async {
    return _handleApiCall<void>(
      () => _dio.post('$_authApiBaseUrl/resend', data: requestModel.toJson()),
      (_) {},
      operationName: '이메일 인증번호 재전송',
    );
  }

  @override
  Future<void> verifyEmailCode(
    EmailVerificationConfirmRequestModel requestModel,
  ) async {
    return _handleApiCall<void>(
      () => _dio.post('$_authApiBaseUrl/verify', data: requestModel.toJson()),
      (_) {},
      operationName: '이메일 인증번호 확인',
    );
  }

  @override
  Future<AuthResponseModel> signup(SignupRequestModel requestModel) async {
    // API 명세의 회원가입 경로는 /signup 이므로 _userApiBaseUrl 사용 (백엔드와 일치시켜야 함)
    return _handleApiCall<AuthResponseModel>(
      () => _dio.post('$_userApiBaseUrl/signup', data: requestModel.toJson()),
      (data) => AuthResponseModel.fromJson(data as Map<String, dynamic>),
      operationName: '회원가입',
    );
  }

  @override
  Future<AuthResponseModel> login(LoginRequestModel requestModel) async {
    // API 명세의 로그인 경로는 /login 이므로 _userApiBaseUrl 사용 (백엔드와 일치시켜야 함)
    return _handleApiCall<AuthResponseModel>(
      () => _dio.post('$_userApiBaseUrl/login', data: requestModel.toJson()),
      (data) => AuthResponseModel.fromJson(data as Map<String, dynamic>),
      operationName: '로그인',
    );
  }

  // 예시: 로그아웃 API가 있다면
  // @override
  // Future<void> logout() async {
  //   return _handleApiCall<void>(
  //     () => _dio.post('$_authApiBaseUrl/logout'), // 실제 로그아웃 API 경로
  //     (_) {},
  //     operationName: '로그아웃',
  //   );
  // }
}
