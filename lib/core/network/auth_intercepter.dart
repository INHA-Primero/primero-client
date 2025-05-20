import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // 토큰 저장소

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage storage; // 또는 토큰을 관리하는 다른 서비스

  AuthInterceptor({required this.storage});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 저장된 액세스 토큰을 읽어옵니다.
    final String? accessToken = await storage.read(
      key: 'access_token',
    ); // 'access_token'은 저장 시 사용한 키

    if (accessToken != null && accessToken.isNotEmpty) {
      // 토큰이 있다면 Authorization 헤더에 추가합니다.
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    // 요청을 계속 진행합니다.
    return super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // (선택 사항) 여기서 401 Unauthorized 에러 발생 시 토큰 갱신 로직을 구현하거나,
    // 로그아웃 처리 후 로그인 화면으로 보내는 등의 공통 에러 처리를 할 수 있습니다.
    if (err.response?.statusCode == 401) {
      print(
        'AuthInterceptor: Received 401, redirecting to login or refreshing token...',
      );
      // 예: await storage.delete(key: 'access_token');
      // 예: navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
    }
    return super.onError(err, handler);
  }
}
