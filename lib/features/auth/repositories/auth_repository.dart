import '../data_sources/local/auth_local_data_source.dart';
import '../data_sources/remote/auth_remote_data_source.dart';
import '../models/email_send_request_model.dart';
import '../models/email_verify_request_model.dart';
import '../models/login_request_model.dart';
import '../models/signup_request_model.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepository(this._remoteDataSource, this._localDataSource);

  Future<void> sendVerificationCode(String email) {
    return _remoteDataSource.sendVerificationCode(
      EmailSendRequestModel(email: email),
    );
  }

  Future<void> verifyCode({required String email, required String code}) {
    return _remoteDataSource.verifyCode(
      EmailVerifyRequestModel(email: email, code: code),
    );
  }

  Future<void> signup(SignupRequestModel request) {
    return _remoteDataSource.signup(request);
  }

  Future<void> login(LoginRequestModel request) async {
    final response = await _remoteDataSource.login(request);
    await _localDataSource.saveAuthData(response);
  }

  Future<void> logout() async {
    await _localDataSource.clearAuthData();
  }

  Future<bool> getAuthStatus() async {
    final token = await _localDataSource.getToken();
    return token != null && token.isNotEmpty;
  }
}
