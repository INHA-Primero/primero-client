import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/features/auth/providers/auth_di.dart'; // dioProvider 공유
import '../data_sources/profile_remote_data_source.dart';
import '../repositories/profile_repository.dart';
import 'profile_notifier.dart';
import 'profile_state.dart';

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((
  ref,
) {
  return ProfileRemoteDataSource(ref.watch(dioProvider));
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(profileRemoteDataSourceProvider));
});

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
      return ProfileNotifier(ref.watch(profileRepositoryProvider));
    });
