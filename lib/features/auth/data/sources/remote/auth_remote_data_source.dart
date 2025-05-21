// lib/features/auth/data/sources/remote/auth_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:primero/features/auth/data/models/auth_response_model.dart';
import 'package:primero/features/auth/data/models/email_verification_confirm_request_model.dart';
import 'package:primero/features/auth/data/models/email_verification_request_model.dart';
import 'package:primero/features/auth/data/models/login_request_model.dart';
import 'package:primero/features/auth/data/models/signup_request_model.dart';

// API 기본 경로: 백엔드 UserController의 @RequestMapping("/api/users") 및
// 다른 AuthController가 /api/auth 등을 사용한다고 가정합니다.
// 실제 배포 시에는 환경에 맞는 URL로 변경해야 합니다.
const String _apiBaseUrl =
    "https://88a37a13-b991-4107-9315-5afcefdf6af3.mock.pstmn.io/api";

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
  Future<AuthResponseModel> signup(
    SignupRequestModel requestModel,
    String deviceUuid,
  );
  Future<AuthResponseModel> login(
    LoginRequestModel requestModel,
    String deviceUuid,
  );
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  // 공통 API 호출 핸들러 (내용은 이전과 유사)
  Future<T> _handleApiCall<T>(
    Future<Response<dynamic>> Function() apiCall,
    T Function(dynamic data) onSuccess, {
    String? operationName,
  }) async {
    final opName = operationName ?? 'API 작업';
    try {
      final response = await apiCall();
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == null && null is T) {
          // void 반환 API 처리
          return null as T;
        }
        // 회원가입 응답이 Long(userId)만 오는 경우에 대한 임시 처리
        if (opName == '회원가입' &&
            response.data is int &&
            T == AuthResponseModel) {
          print(
            "Warning: Signup API returned only userId ($response.data). Constructing partial AuthResponseModel. Backend should return full AuthResponseModel including tokens.",
          );
          // !!! 백엔드에서 AuthResponseModel과 일치하는 JSON(토큰 포함)을 반환하도록 수정하는 것이 최선입니다 !!!
          return AuthResponseModel(
                userId: response.data as int,
                barcodeUrl: "TEMP_BARCODE_URL_SIGNUP",
                accessToken: null,
                refreshToken: null,
              )
              as T;
        }
        // 로그인 및 기타 정상적인 JSON 응답 처리
        if (response.data is Map<String, dynamic>) {
          return onSuccess(response.data);
        }
        // 예상치 못한 응답 형식
        throw Exception(
          "$opName 응답 형식이 예상과 다릅니다: ${response.data?.runtimeType}, data: ${response.data}",
        );
      } else {
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
    // 이메일 인증 API가 /api/auth/email 경로를 사용한다고 가정
    return _handleApiCall<void>(
      () => _dio.post('$_apiBaseUrl/auth/email', data: requestModel.toJson()),
      (_) {},
      operationName: '이메일 인증 요청',
    );
  }

  @override
  Future<void> resendEmailVerification(
    EmailVerificationRequestModel requestModel,
  ) async {
    return _handleApiCall<void>(
      () => _dio.post('$_apiBaseUrl/auth/resend', data: requestModel.toJson()),
      (_) {},
      operationName: '이메일 인증번호 재전송',
    );
  }

  @override
  Future<void> verifyEmailCode(
    EmailVerificationConfirmRequestModel requestModel,
  ) async {
    return _handleApiCall<void>(
      () => _dio.post('$_apiBaseUrl/auth/verify', data: requestModel.toJson()),
      (_) {},
      operationName: '이메일 인증번호 확인',
    );
  }

  @override
  Future<AuthResponseModel> signup(
    SignupRequestModel requestModel,
    String deviceUuid,
  ) async {
    // 백엔드 UserController의 경로가 /api/users/signup 이므로, 이를 따름
    // deviceUuid는 X-DEVICE-UUID 헤더로 전송
    return _handleApiCall<AuthResponseModel>(
      () => _dio.post(
        '$_apiBaseUrl/users/signup', // 경로 수정
        data: requestModel.toJson(),
        options: Options(headers: {'X-DEVICE-UUID': deviceUuid}), // 헤더 추가
      ),
      (data) {
        // onSuccess 콜백
        if (data is int) {
          // 백엔드가 userId(Long)만 반환하는 경우
          print(
            "Signup API returned userId: $data. Creating temporary AuthResponseModel. Please ask backend to return full AuthResponseModel with tokens.",
          );
          return AuthResponseModel(
            userId: data,
            barcodeUrl: "TEMP_BARCODE_SIGNUP",
            accessToken: null,
            refreshToken: null,
          );
        } else if (data is Map<String, dynamic>) {
          return AuthResponseModel.fromJson(data);
        }
        throw Exception("회원가입 응답 형식이 예상과 다릅니다: $data");
      },
      operationName: '회원가입',
    );
  }

  @override
  Future<AuthResponseModel> login(
    LoginRequestModel requestModel,
    String deviceUuid,
  ) async {
    // 로그인 API 경로도 /api/users/login 이고, deviceUuid를 헤더로 받는다고 가정 (백엔드 확인 필요)
    // 만약 AuthController에 있다면 /api/auth/login 등으로 변경
    return _handleApiCall<AuthResponseModel>(
      () => _dio.post(
        '$_apiBaseUrl/users/login', // 경로 예시 (백엔드 확인 필요)
        data: requestModel.toJson(),
        options: Options(headers: {'X-DEVICE-UUID': deviceUuid}), // 헤더 추가
      ),
      (data) => AuthResponseModel.fromJson(data as Map<String, dynamic>),
      operationName: '로그인',
    );
  }
}
