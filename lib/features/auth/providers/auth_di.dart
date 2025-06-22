// lib/features/auth/providers/auth_di.dart

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:primero/core/network/auth_intercepter.dart';
import 'package:primero/core/services/device_uuid_service.dart';
import 'package:primero/features/profile/providers/profile_di.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../data_sources/local/auth_local_data_source.dart';
import '../data_sources/remote/auth_remote_data_source.dart';
import '../repositories/auth_repository.dart';
import 'auth_notifier.dart';
import 'auth_state.dart';

// --- ✨ [추가] Core Services DI ---
// 앱 전반에서 사용될 수 있는 핵심 서비스들의 Provider를 정의합니다.

// FlutterSecureStorage 인스턴스를 제공합니다.
final flutterSecureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);

// Uuid 인스턴스를 제공합니다.
final uuidProvider = Provider<Uuid>((ref) => const Uuid());

// DeviceUuidService를 위한 Provider를 추가합니다.
// 이 서비스는 기기의 고유 ID를 생성하고 안전하게 관리하는 역할을 합니다.
final deviceUuidServiceProvider = Provider<DeviceUuidService>((ref) {
  return DeviceUuidService(
    secureStorage: ref.watch(flutterSecureStorageProvider),
    uuid: ref.watch(uuidProvider),
  );
});
// ---

// Dio(HTTP 클라이언트) 설정
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );
  dio.interceptors.add(AuthInterceptor(ref));
  return dio;
});

// SharedPreferences 인스턴스 (비동기)
final sharedPreferencesProvider = FutureProvider<SharedPreferences>(
  (ref) => SharedPreferences.getInstance(),
);

// 데이터 소스 (로컬/원격)
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).asData!.value;
  return AuthLocalDataSourceImpl(prefs);
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRemoteDataSource(dio, baseUrl: "http://35.216.76.60:8080");
});

// 리포지토리
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final localDataSource = ref.watch(authLocalDataSourceProvider);
  return AuthRepository(remoteDataSource, localDataSource);
});

// 상태 관리자 (State Notifier)
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  final authRepository = ref.watch(authRepositoryProvider);
  final profileRepository = ref.watch(profileRepositoryProvider);
  return AuthNotifier(authRepository, profileRepository);
});
