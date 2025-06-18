import 'package:primero/features/home/data_sources/home_remote_data_source.dart';
import 'package:primero/features/home/models/character_info_model.dart';

class HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;
  // API 연동 테스트를 위한 플래그
  final bool _useMockData = true; // 이 값을 false로 바꾸면 실제 API를 호출합니다.

  HomeRepository(this._remoteDataSource);

  Future<CharacterInfoModel> getCharacterInfo() {
    if (_useMockData) {
      // --- 💡 가짜(Mock) 데이터 사용 ---
      // 1초 후, 미리 정의된 가짜 캐릭터 정보를 반환합니다.
      return Future.delayed(
        const Duration(seconds: 1),
        () => const CharacterInfoModel(
          characterId: 1,
          userId: 1,
          exp: 260, // 예: 레벨 3 (200) + 경험치 60
          wateringChance: 3,
          nickname: '인하코드트리',
        ),
      );
    } else {
      // --- 실제 API 호출 ---
      return _remoteDataSource.getCharacterInfo();
    }
  }
}
