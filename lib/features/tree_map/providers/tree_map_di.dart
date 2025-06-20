import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/features/auth/providers/auth_di.dart';
import 'package:primero/features/tree_map/data_sources/tree_map_remote_data_source.dart';
import 'package:primero/features/tree_map/providers/tree_map_notifier.dart';
import 'package:primero/features/tree_map/providers/tree_map_state.dart';
import 'package:primero/features/tree_map/repositories/tree_map_repository.dart';

// TreeMapRemoteDataSource Provider
final treeMapRemoteDataSourceProvider = Provider<TreeMapRemoteDataSource>((
  ref,
) {
  // 기존 auth_di.dart에 정의된 dioProvider를 재사용합니다.
  final dio = ref.watch(dioProvider);

  // DataSource 파일에서 baseUrl을 직접 관리하므로, 여기서는 생성자에 baseUrl을 넘기지 않습니다.
  return TreeMapRemoteDataSource(dio);
});

// TreeMapRepository Provider
final treeMapRepositoryProvider = Provider<TreeMapRepository>((ref) {
  final remoteDataSource = ref.watch(treeMapRemoteDataSourceProvider);
  final localDataSource = ref.watch(authLocalDataSourceProvider);
  return TreeMapRepository(remoteDataSource, localDataSource);
});

// TreeMapNotifier Provider
final treeMapNotifierProvider =
    StateNotifierProvider<TreeMapNotifier, TreeMapState>((ref) {
      final repository = ref.watch(treeMapRepositoryProvider);
      return TreeMapNotifier(repository);
    });
