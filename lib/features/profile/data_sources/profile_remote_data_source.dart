// lib/features/profile/data_sources/profile_remote_data_source.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/auth_log_res.dart';
import '../models/user_profile_model.dart';
import '../models/user_modify_request_model.dart';

part 'profile_remote_data_source.g.dart';

@RestApi(baseUrl: "http://localhost:8080")
abstract class ProfileRemoteDataSource {
  // ✨ 수정: errorLogger 파라미터 제거
  factory ProfileRemoteDataSource(Dio dio, {String baseUrl}) =
      _ProfileRemoteDataSource;

  @GET('/api/users/me')
  Future<UserProfileModel> getUserProfile();

  @PUT('/api/users/{userId}')
  Future<void> updateUserProfile(
    @Path("userId") int userId,
    @Body() UserModifyRequestModel request,
  );

  @MultiPart()
  @POST('/{userId}/profile-image')
  Future<String> uploadProfileImage(
    @Path("userId") int userId,
    @Part(name: "file") File image,
  );

  @DELETE('/api/users/{userId}')
  Future<void> deleteUser(@Path("userId") int userId);

  @GET('/api/barcode/log/{userId}')
  Future<List<AuthLogRes>> getAuthLogs(@Path("userId") int userId);
}
