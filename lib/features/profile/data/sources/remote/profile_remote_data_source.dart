// lib/features/profile/data/sources/remote/profile_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:primero/features/profile/data/models/user_profile_model.dart';

// TODO: 실제 API 서버의 기본 URL로 반드시 변경해주세요!
const String _apiBaseUrl =
    "https://88a37a13-b991-4107-9315-5afcefdf6af3.mock.pstmn.io"; // Mock Server URL 또는 실제 서버 URL

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> fetchUserProfile();

  /// 프로필 정보(닉네임, 프로필 이미지 URL)를 업데이트합니다.
  Future<UserProfileModel> updateUserProfile(Map<String, dynamic> dataToUpdate);

  /// 비밀번호를 변경합니다.
  Future<void> changePassword(Map<String, dynamic> passwordData);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserProfileModel> fetchUserProfile() async {
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
    // API 명세에 따라 "name"은 요청 본문에서 제외되었습니다.
    // "nickname", "profileImageUrl"만 포함될 수 있습니다.
    try {
      final response = await dio.patch(
        '$_apiBaseUrl/users/me',
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
    // API 명세: POST /users/me/password
    // 요청 본문: {"currentPassword": "...", "newPassword": "..."}
    try {
      final response = await dio.post(
        '$_apiBaseUrl/users/me/password',
        data: passwordData,
      );
      // 성공 시 200 OK 또는 204 No Content 등을 예상할 수 있습니다.
      // API 명세에 따라 성공 조건을 확인합니다.
      if (response.statusCode == 200 || response.statusCode == 204) {
        // 성공 (특별히 반환할 데이터가 없을 수 있음)
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
}
