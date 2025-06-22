// lib/features/auth/data_sources/remote/auth_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../models/email_send_request_model.dart';
import '../../models/email_verify_request_model.dart';
import '../../models/login_request_model.dart';
import '../../models/login_response_model.dart';
import '../../models/signup_request_model.dart';

part 'auth_remote_data_source.g.dart';

@RestApi(baseUrl: "http://35.216.76.60:8080")
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio, {String baseUrl}) =
      _AuthRemoteDataSource;

  @POST('/api/auth/send')
  Future<void> sendVerificationCode(@Body() EmailSendRequestModel request);

  @POST('/api/auth/verify')
  Future<void> verifyCode(@Body() EmailVerifyRequestModel request);

  @POST('/api/users/signup')
  Future<void> signup(@Body() SignupRequestModel request);

  @POST('/api/login')
  Future<LoginResponseModel> login(@Body() LoginRequestModel request);
}
