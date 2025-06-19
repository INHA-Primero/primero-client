import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/data_sources/local/auth_local_data_source.dart';
import '../../features/auth/providers/auth_di.dart';

class AuthInterceptor extends Interceptor {
  final Ref ref;

  AuthInterceptor(this.ref);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path.contains('/login') ||
        options.path.contains('/users/signup')) {
      return handler.next(options);
    }

    // AuthLocalDataSource에서 새로운 방식으로 토큰을 가져옵니다.
    final token = await ref.read(authLocalDataSourceProvider).getToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {

    if (err.response?.statusCode == 401) {
      // 예: ref.read(authNotifierProvider.notifier).logout();
    }

    return handler.next(err);
  }
}
