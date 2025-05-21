// lib/features/profile/presentation/providers/profile_di.dart
// import 'dart:io'; // File 사용을 위해 추가 (UploadProfileImageUseCase 때문) - 이미 다른 곳에서 import 될 수 있음
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:primero/features/profile/data/sources/remote/profile_remote_data_source.dart';
import 'package:primero/features/profile/domain/repositories/profile_repository.dart';
import 'package:primero/features/profile/domain/usecases/change_password_usecase.dart';
import 'package:primero/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:primero/features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:primero/features/profile/domain/usecases/upload_profile_image_usecase.dart'; // 추가
import 'package:primero/features/profile/presentation/providers/profile_notifier.dart';
import 'package:primero/features/profile/presentation/providers/profile_state.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // AuthInterceptor 예시용
// import 'package:primero/core/network/auth_intercepter.dart'; // AuthInterceptor 예시용

// final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) => const FlutterSecureStorage()); // AuthInterceptor 예시용

final profileFeatureDioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  // 요청/응답 시간을 늘리고 싶다면 (기본값은 각각 8초)
  // dio.options.connectTimeout = Duration(seconds: 15); // 15초
  // dio.options.receiveTimeout = Duration(seconds: 15); // 15초

  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
      requestHeader: true, // 요청 헤더도 로그에 포함
      responseHeader: false, // 응답 헤더는 제외 (필요시 true)
    ),
  );
  // TODO: 실제 AuthInterceptor를 추가하고, 토큰을 주입해야 합니다.
  // final storage = ref.watch(flutterSecureStorageProvider);
  // dio.interceptors.add(AuthInterceptor(storage: storage));
  return dio;
});

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((
  ref,
) {
  return ProfileRemoteDataSourceImpl(dio: ref.watch(profileFeatureDioProvider));
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    remoteDataSource: ref.watch(profileRemoteDataSourceProvider),
  );
});

final getUserProfileUseCaseProvider = Provider<GetUserProfileUseCase>((ref) {
  return GetUserProfileUseCase(ref.watch(profileRepositoryProvider));
});

final updateUserProfileUseCaseProvider = Provider<UpdateUserProfileUseCase>((
  ref,
) {
  return UpdateUserProfileUseCase(ref.watch(profileRepositoryProvider));
});

final changePasswordUseCaseProvider = Provider<ChangePasswordUseCase>((ref) {
  return ChangePasswordUseCase(ref.watch(profileRepositoryProvider));
});

// UploadProfileImageUseCase Provider 추가
final uploadProfileImageUseCaseProvider = Provider<UploadProfileImageUseCase>((
  ref,
) {
  return UploadProfileImageUseCase(ref.watch(profileRepositoryProvider));
});

final profileNotifierProvider = StateNotifierProvider<
  ProfileNotifier,
  ProfileState
>((ref) {
  // TODO: 실제 사용자 ID를 인증 시스템에서 가져와서 ProfileNotifier에 전달해야 합니다.
  // final String userId = ref.watch(authNotifierProvider.select((auth) => auth.userId)); // 예시
  return ProfileNotifier(
    getUserProfileUseCase: ref.watch(getUserProfileUseCaseProvider),
    updateUserProfileUseCase: ref.watch(updateUserProfileUseCaseProvider),
    changePasswordUseCase: ref.watch(changePasswordUseCaseProvider),
    uploadProfileImageUseCase: ref.watch(
      uploadProfileImageUseCaseProvider,
    ), // 주입
    // userId: userId, // 실제 사용자 ID 전달
  );
});
