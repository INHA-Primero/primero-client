// lib/features/profile/presentation/providers/profile_di.dart
// (이전 답변의 profile_di_code_v3 와 동일 - 변경 없음)
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:primero/features/profile/data/sources/remote/profile_remote_data_source.dart';
import 'package:primero/features/profile/domain/repositories/profile_repository.dart';
import 'package:primero/features/profile/domain/usecases/change_password_usecase.dart';
import 'package:primero/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:primero/features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:primero/features/profile/presentation/providers/profile_notifier.dart';
import 'package:primero/features/profile/presentation/providers/profile_state.dart';

final profileFeatureDioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.interceptors.add(
    LogInterceptor(requestBody: true, responseBody: true, error: true),
  );
  // TODO: AuthInterceptor 추가
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

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
      return ProfileNotifier(
        getUserProfileUseCase: ref.watch(getUserProfileUseCaseProvider),
        updateUserProfileUseCase: ref.watch(updateUserProfileUseCaseProvider),
        changePasswordUseCase: ref.watch(changePasswordUseCaseProvider),
        // userId: ref.watch(authUserIdProvider), // 실제 userId 주입
      );
    });
