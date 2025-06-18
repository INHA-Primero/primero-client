import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/data_sources/local/auth_local_data_source.dart';
import '../../features/auth/providers/auth_di.dart'; // authLocalDataSourceProvider를 가져오기 위해

class AuthInterceptor extends Interceptor {
  final Ref ref;

  AuthInterceptor(this.ref);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // '/login', '/signup' 같은 경로는 토큰이 필요 없으므로 그냥 통과시킵니다.
    if (options.path.contains('/login') ||
        options.path.contains('/users/signup')) {
      return handler.next(options);
    }

    // AuthLocalDataSource에서 새로운 방식으로 토큰을 가져옵니다.
    final token = await ref.read(authLocalDataSourceProvider).getToken();

    if (token != null) {
      // 헤더에 'Bearer' 토큰을 추가합니다.
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // TODO: 토큰 만료(401 에러) 시, 토큰 재발급 로직이 필요하다면 여기에 구현합니다.
    // 현재 API 명세에는 refresh token이 없으므로, 만료 시 로그인 화면으로 보내는 로직을 구현할 수 있습니다.
    if (err.response?.statusCode == 401) {
      // 예: ref.read(authNotifierProvider.notifier).logout();
    }

    return handler.next(err);
  }
}
