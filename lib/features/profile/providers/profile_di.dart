import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/features/auth/providers/auth_di.dart';
import 'package:primero/features/home/providers/home_di.dart';
import '../data_sources/profile_remote_data_source.dart';
import '../repositories/profile_repository.dart';
import 'profile_notifier.dart';
import 'profile_state.dart';

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return ProfileRemoteDataSource(dio);
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  // Repository에서 AuthLocalDataSource 의존성 제거
  final remoteDataSource = ref.watch(profileRemoteDataSourceProvider);
  return ProfileRepository(remoteDataSource);
});

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
      return ProfileNotifier(
        ref.watch(profileRepositoryProvider),
        ref.watch(homeRepositoryProvider),
        ref,
      );
    });
