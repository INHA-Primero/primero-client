import 'package:primero/features/auth/data_sources/local/auth_local_data_source.dart';
import 'package:primero/features/tree_map/data_sources/tree_map_remote_data_source.dart';
import 'package:primero/features/tree_map/models/tree_model.dart';

class TreeMapRepository {
  final TreeMapRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  TreeMapRepository(this._remoteDataSource, this._localDataSource);

  // 오류 해결을 위해 가장 방어적인 코드로 수정했습니다.
  Future<int?> getMyUserId() async {
    // getUserId()가 어떤 타입을 반환하든 안전하게 처리합니다.
    final dynamic userIdFromStorage = await _localDataSource.getUserId();

    if (userIdFromStorage == null) {
      print('[TreeMapRepository] User ID not found in local storage.');
      return null;
    }

    // 어떤 타입이든 문자열로 변환 후 파싱을 시도합니다.
    final userIdAsString = userIdFromStorage.toString();
    final parsedId = int.tryParse(userIdAsString);

    if (parsedId == null) {
      print('[TreeMapRepository] Failed to parse User ID: $userIdAsString');
    }

    return parsedId;
  }

  Future<List<TreeModel>> getMyTrees(int userId) async {
    try {
      return await _remoteDataSource.getMyTrees(userId);
    } catch (e) {
      print('[TreeMapRepository] Failed to fetch trees: $e');
      rethrow;
    }
  }
}
