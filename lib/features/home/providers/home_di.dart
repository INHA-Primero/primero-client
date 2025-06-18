import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/features/auth/providers/auth_di.dart';
import 'package:primero/features/home/data_sources/home_remote_data_source.dart';
import 'package:primero/features/home/providers/home_notifier.dart';
import 'package:primero/features/home/providers/home_state.dart';
import 'package:primero/features/home/repositories/home_repository.dart';
import 'package:primero/features/profile/providers/profile_di.dart';

// 홈 기능에 대한 의존성 주입(DI) 설정입니다.

final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return HomeRemoteDataSource(dio);
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final remoteDataSource = ref.watch(homeRemoteDataSourceProvider);
  return HomeRepository(remoteDataSource);
});

final homeNotifierProvider = StateNotifierProvider<HomeNotifier, HomeState>((
  ref,
) {
  final profileRepository = ref.watch(profileRepositoryProvider);
  final homeRepository = ref.watch(homeRepositoryProvider);
  return HomeNotifier(profileRepository, homeRepository);
});
