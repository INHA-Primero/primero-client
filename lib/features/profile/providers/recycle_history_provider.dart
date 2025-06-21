import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/features/profile/models/recycle_history_model.dart';
import 'package:primero/features/profile/providers/profile_di.dart';

// ✨ [추가] 프로필 화면의 최근 기록 목록을 위한 전용 Provider
// .family가 없으므로 파라미터가 필요 없고, 매번 재생성되지 않습니다.
final recentRecycleHistoryProvider =
    FutureProvider.autoDispose<PageRecycleListResponse>((ref) {
      final repository = ref.watch(profileRepositoryProvider);
      // page와 size를 0과 10으로 고정하여 API를 호출합니다.
      return repository.getRecycleHistory(page: 0, size: 10);
    });

// [기존 코드 유지] 페이지네이션이 필요한 다른 화면을 위해 .family Provider는 그대로 둡니다.
final recycleHistoryProvider = FutureProvider.autoDispose
    .family<PageRecycleListResponse, Map<String, int>>((ref, params) async {
      final page = params['page'] ?? 0;
      final size = params['size'] ?? 20;
      final repository = ref.watch(profileRepositoryProvider);
      return repository.getRecycleHistory(page: page, size: size);
    });

// 분리수거 기록 상세 정보를 위한 Provider (기존 코드 유지)
final recycleDetailProvider = FutureProvider.autoDispose
    .family<RecycleDetail, int>((ref, id) async {
      final repository = ref.watch(profileRepositoryProvider);
      return repository.getRecycleDetail(id: id);
    });
