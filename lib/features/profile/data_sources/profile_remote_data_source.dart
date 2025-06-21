import 'dart:io';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/recycle_history_model.dart';
import '../models/user_profile_model.dart';
import '../models/user_modify_request_model.dart';

part 'profile_remote_data_source.g.dart';

@RestApi(baseUrl: "http://35.216.76.60:8080")
abstract class ProfileRemoteDataSource {
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

  // --- 분리수거 인증 기록 API (수정) ---

  // @Header("Authorization") 파라미터를 제거합니다.
  // AuthInterceptor가 이 역할을 대신합니다.
  @GET('/api/v1/recycles')
  Future<PageRecycleListResponse> getRecycleHistory({
    @Query("page") required int page,
    @Query("size") required int size,
  });

  @GET('/api/v1/recycles/{id}')
  Future<RecycleDetail> getRecycleDetail({@Path('id') required int id});
}
