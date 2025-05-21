// lib/features/profile/data/sources/remote/profile_remote_data_source.dart
import 'dart:io'; // File 사용을 위해 추가
import 'package:dio/dio.dart';
import 'package:primero/features/profile/data/models/user_profile_model.dart';

// TODO: 실제 API 서버의 기본 URL로 반드시 변경해주세요!
const String _apiBaseUrl =
    "https://88a37a13-b991-4107-9315-5afcefdf6af3.mock.pstmn.io"; // Mock Server URL 또는 실제 서버 URL

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> fetchUserProfile();
  Future<UserProfileModel> updateUserProfile(Map<String, dynamic> dataToUpdate);
  Future<void> changePassword(Map<String, dynamic> passwordData);

  /// 이미지 파일을 서버에 업로드하고, 저장된 이미지의 URL을 반환합니다.
  Future<String> uploadProfileImage(File imageFile);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserProfileModel> fetchUserProfile() async {
    // 기존 구현과 동일
    try {
      final response = await dio.get('$_apiBaseUrl/users/me');
      if (response.statusCode == 200 && response.data != null) {
        return UserProfileModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: '프로필 정보 로드 실패: 상태 코드 ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('DioException in fetchUserProfile: ${e.message}');
      throw Exception(
        '서버 통신 중 오류가 발생했습니다: ${e.response?.data?['error'] ?? e.message}',
      );
    } catch (e) {
      print('Unexpected error in fetchUserProfile: $e');
      throw Exception('프로필 정보를 가져오는 중 알 수 없는 오류가 발생했습니다.');
    }
  }

  @override
  Future<UserProfileModel> updateUserProfile(
    Map<String, dynamic> dataToUpdate,
  ) async {
    // 기존 구현과 동일 (단, profileImageUrl이 null로 올 수 있음을 서버가 처리해야 함)
    try {
      final response = await dio.patch(
        '$_apiBaseUrl/users/me', // 프로필 정보 업데이트 API (닉네임, 이미지 URL 등)
        data: dataToUpdate,
      );
      if (response.statusCode == 200 && response.data != null) {
        return UserProfileModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: '프로필 업데이트 실패: 상태 코드 ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('DioException in updateUserProfile: ${e.message}');
      String errorMessage = '프로필 업데이트 중 서버 통신 오류가 발생했습니다.';
      if (e.response?.data is Map<String, dynamic>) {
        errorMessage =
            (e.response!.data as Map<String, dynamic>)['error']?.toString() ??
            (e.response!.data as Map<String, dynamic>)['message']?.toString() ??
            e.message ??
            errorMessage;
      } else if (e.message != null) {
        errorMessage = e.message!;
      }
      throw Exception(errorMessage);
    } catch (e) {
      print('Unexpected error in updateUserProfile: $e');
      throw Exception('프로필 업데이트 중 알 수 없는 오류가 발생했습니다.');
    }
  }

  @override
  Future<void> changePassword(Map<String, dynamic> passwordData) async {
    // 기존 구현과 동일
    try {
      final response = await dio.post(
        '$_apiBaseUrl/users/me/password',
        data: passwordData,
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: '비밀번호 변경 실패: 상태 코드 ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('DioException in changePassword: ${e.message}');
      String errorMessage = '비밀번호 변경 중 서버 통신 오류가 발생했습니다.';
      if (e.response?.data is Map<String, dynamic>) {
        errorMessage =
            (e.response!.data as Map<String, dynamic>)['error']?.toString() ??
            (e.response!.data as Map<String, dynamic>)['message']?.toString() ??
            e.message ??
            errorMessage;
      } else if (e.message != null) {
        errorMessage = e.message!;
      }
      throw Exception(errorMessage);
    } catch (e) {
      print('Unexpected error in changePassword: $e');
      throw Exception('비밀번호 변경 중 알 수 없는 오류가 발생했습니다.');
    }
  }

  @override
  Future<String> uploadProfileImage(File imageFile) async {
    // !!! 중요: 실제 백엔드 이미지 업로드 API 엔드포인트로 수정해야 합니다. !!!
    const String uploadUrl =
        '$_apiBaseUrl/users/me/avatar'; // 예시: 사용자 아바타 업로드 API
    try {
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        // 서버에서 파일을 받는 필드명 (예: "avatar", "file", "profile_image" 등)
        // 백엔드와 협의하여 정확한 필드명을 사용해야 합니다.
        "avatar": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      // TODO: 인증 토큰이 필요하다면 Dio Interceptor를 통해 헤더에 추가해야 합니다.
      final response = await dio.post(uploadUrl, data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 서버 응답에서 이미지 URL을 추출하는 방식은 실제 API 명세에 따라야 합니다.
        // 일반적인 경우: {"imageUrl": "https://..."} 또는 {"data": {"imageUrl": "https://..."}}
        if (response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;
          // 서버 응답 구조에 따라 아래 키들을 적절히 수정해야 합니다.
          if (responseData.containsKey('imageUrl')) {
            return responseData['imageUrl'] as String;
          } else if (responseData.containsKey('data') &&
              responseData['data'] is Map &&
              responseData['data']['profileImageUrl'] != null) {
            return responseData['data']['profileImageUrl'] as String;
          } else if (responseData.containsKey('data') &&
              responseData['data'] is Map &&
              responseData['data']['imageUrl'] != null) {
            // 다른 가능한 키
            return responseData['data']['imageUrl'] as String;
          }
        }
        // 만약 서버가 URL 문자열만 직접 반환한다면:
        // if (response.data is String) {
        //   return response.data as String;
        // }
        throw Exception('이미지 URL을 응답에서 찾을 수 없습니다. 응답 데이터: ${response.data}');
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error:
              '이미지 업로드 실패: 상태 코드 ${response.statusCode}, 메시지: ${response.data}',
        );
      }
    } on DioException catch (e) {
      print(
        'DioException in uploadProfileImage: ${e.message}, Response: ${e.response?.data}',
      );
      // 서버에서 구체적인 에러 메시지를 내려준다면 그것을 사용
      String errorMessage = '이미지 업로드 중 서버 통신 오류가 발생했습니다.';
      if (e.response?.data is Map<String, dynamic>) {
        errorMessage =
            (e.response!.data as Map<String, dynamic>)['message']?.toString() ??
            (e.response!.data as Map<String, dynamic>)['error']?.toString() ??
            e.message ??
            errorMessage;
      } else if (e.message != null) {
        errorMessage = e.message!;
      }
      throw Exception(errorMessage);
    } catch (e) {
      print('Unexpected error in uploadProfileImage: $e');
      throw Exception('이미지 업로드 중 알 수 없는 오류가 발생했습니다.');
    }
  }
}
