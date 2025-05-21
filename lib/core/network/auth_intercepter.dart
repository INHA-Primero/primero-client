// lib/core/network/auth_intercepter.dart
import 'package:dio/dio.dart';
import 'package:primero/features/auth/data/sources/local/auth_local_data_source.dart';

class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource _localDataSource;

  // 생성자를 통해 AuthLocalDataSource 인스턴스를 주입받습니다.
  // 이를 통해 SecureStorage에 저장된 토큰에 접근할 수 있습니다.
  AuthInterceptor(this._localDataSource);

  // 1. onRequest: HTTP 요청이 서버로 전송되기 직전에 호출됩니다.
  @override
  Future<void> onRequest(
    RequestOptions options, // 현재 요청에 대한 정보 및 설정 (경로, 메서드, 헤더 등)
    RequestInterceptorHandler
    handler, // 요청을 계속 진행하거나, 중단하거나, 응답으로 바로 완료시킬 수 있는 핸들러
  ) async {
    // 특정 경로들은 AccessToken 없이 요청되어야 합니다. (예: 로그인, 회원가입, 이메일 인증 관련 API)
    final noAuthPaths = [
      '/auth/email', // 이메일 인증 요청
      '/auth/resend', // 인증번호 재전송
      '/auth/verify', // 인증번호 확인
      '/signup', // 회원가입
      '/login', // 로그인
      // 여기에 토큰 없이 접근해야 하는 다른 경로들을 추가할 수 있습니다.
      // 예: '/public/posts', '/version-check' 등
    ];

    // 현재 요청 경로(options.path)가 noAuthPaths에 포함된 경로로 끝나는지 확인합니다.
    // options.path는 보통 전체 URL이므로, endsWith를 사용하여 API의 엔드포인트 부분만 비교합니다.
    if (noAuthPaths.any((path) => options.path.endsWith(path))) {
      print('AuthInterceptor: No auth header for ${options.path}');
      // 토큰이 필요 없는 요청이므로, 아무런 추가 작업 없이 요청을 계속 진행합니다.
      return super.onRequest(options, handler); // 또는 handler.next(options);
    }

    // 토큰이 필요한 API 요청의 경우, 로컬 저장소에서 AccessToken을 비동기적으로 가져옵니다.
    final accessToken = await _localDataSource.getAccessToken();
    print(
      'AuthInterceptor: onRequest - path: ${options.path}, token: $accessToken',
    );

    if (accessToken != null && accessToken.isNotEmpty) {
      // AccessToken이 존재하면, 요청 헤더의 'Authorization' 필드에 'Bearer <토큰값>' 형식으로 추가합니다.
      options.headers['Authorization'] = 'Bearer $accessToken';
      print('AuthInterceptor: Authorization header added.');
    } else {
      // AccessToken이 없는 경우 (예: 로그아웃 상태이거나 토큰이 아직 발급되지 않음)
      print('AuthInterceptor: No access token found for Authorization header.');
      // 이 경우, 대부분의 보호된 API는 서버에서 401 Unauthorized 에러를 반환할 것입니다.
      // 요청을 그대로 보내거나, 여기서 에러를 발생시켜 요청을 중단할 수도 있습니다.
      // 현재 코드는 토큰이 없어도 일단 요청을 보냅니다.
    }
    // 모든 처리가 완료되면 요청을 계속 진행합니다.
    return super.onRequest(options, handler); // 또는 handler.next(options);
  }

  // 2. onError: HTTP 요청 중 에러가 발생했을 때 호출됩니다. (예: 네트워크 오류, 서버 에러 응답)
  @override
  Future<void> onError(
    DioException err, // 발생한 Dio 에러 객체
    ErrorInterceptorHandler handler, // 에러를 계속 전파하거나, 새로운 응답으로 복구할 수 있는 핸들러
  ) async {
    print(
      'AuthInterceptor: onError - path: ${err.requestOptions.path}, statusCode: ${err.response?.statusCode}',
    );

    // HTTP 응답 상태 코드가 401(Unauthorized)인 경우를 특별히 처리합니다.
    // 이는 주로 AccessToken이 만료되었거나 유효하지 않을 때 발생합니다.
    if (err.response?.statusCode == 401) {
      print('AuthInterceptor: Received 401 Unauthorized error.');

      // 1. 저장된 토큰(AccessToken, RefreshToken)을 삭제하여 로컬의 인증 상태를 초기화합니다.
      await _localDataSource.deleteTokens();
      print('AuthInterceptor: Tokens deleted.');

      // 2. 사용자에게 알리고 로그인 화면으로 리다이렉트해야 합니다.
      //    !!! 중요 !!!: 인터셉터에서 직접 UI를 조작하거나 라우팅하는 것은 좋지 않은 패턴입니다.
      //    대신, 앱의 상태 관리자(예: AuthNotifier)가 이 상황을 인지하고 상태를 변경하도록 해야 합니다.
      //    AuthNotifier는 AuthUnauthenticated 상태로 변경하고,
      //    GoRouter의 redirect 로직이나 앱의 최상위 위젯에서 이 상태 변화를 감지하여
      //    자동으로 로그인 화면으로 보내는 것이 올바른 접근 방식입니다.
      //    여기서는 로그만 남기고, 실제 로그아웃 및 리다이렉션은 AuthNotifier와 라우터가 담당하도록
      //    유도하기 위해 에러를 그대로 전파합니다.
      print(
        'AuthInterceptor: User should be logged out and redirected to login via AuthNotifier & Router.',
      );

      // TODO: (고급 기능) 리프레시 토큰을 사용한 AccessToken 자동 재발급 로직
      // final refreshToken = await _localDataSource.getRefreshToken();
      // if (refreshToken != null && refreshToken.isNotEmpty && err.requestOptions.path != '/auth/refresh-token') { // 무한 루프 방지
      //   try {
      //     print('AuthInterceptor: Attempting to refresh token.');
      //     // 별도의 Dio 인스턴스(인터셉터가 없는)를 사용하여 토큰 재발급 API 호출
      //     // final newAuthResponse = await _refreshTokenApiCall(refreshToken); // 예시 API 호출
      //     // await _localDataSource.saveTokens(
      //     //   accessToken: newAuthResponse.accessToken!,
      //     //   refreshToken: newAuthResponse.refreshToken
      //     // );
      //     // print('AuthInterceptor: Token refreshed successfully.');
      //     // 원래 실패했던 요청을 새 토큰으로 재시도
      //     // final newOptions = err.requestOptions;
      //     // newOptions.headers['Authorization'] = 'Bearer ${newAuthResponse.accessToken!}';
      //     // final response = await _dio.request( // _dio는 인터셉터가 없는 새 인스턴스 또는 현재 인터셉터를 임시 제거한 Dio
      //     //   newOptions.path,
      //     //   options: Options(method: newOptions.method, headers: newOptions.headers),
      //     //   data: newOptions.data,
      //     //   queryParameters: newOptions.queryParameters,
      //     // );
      //     // return handler.resolve(response); // 요청 성공으로 처리
      //   } catch (refreshError) {
      //     print('AuthInterceptor: Failed to refresh token - $refreshError');
      //     // 토큰 재발급 실패 시에는 기존처럼 로그아웃 처리 (아래 handler.next(err)로 에러 전파)
      //   }
      // }

      // 401 에러를 그대로 다음 핸들러(또는 Dio 클라이언트)로 전파합니다.
      // 이렇게 하면 Repository나 UseCase 레벨에서 이 에러를 잡아서 특정 로직을 수행하거나,
      // AuthNotifier가 상태를 변경하여 UI에 반영할 수 있습니다.
      return handler.next(err);
    }
    // 401이 아닌 다른 에러는 그대로 다음 핸들러로 전파합니다.
    return super.onError(err, handler); // 또는 handler.next(err);
  }
}
