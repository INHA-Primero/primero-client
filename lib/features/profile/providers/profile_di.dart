
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/features/auth/providers/auth_di.dart'; // dioProvider 공유
import 'package:primero/features/home/providers/home_di.dart'; // ✨ homeRepositoryProvider를 import
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
  return ProfileNotifier(
    ref.watch(profileRepositoryProvider),
    ref.watch(homeRepositoryProvider),
    ref, // ✨ [수정] ref 자체를 ProfileNotifier에 전달
  );
});