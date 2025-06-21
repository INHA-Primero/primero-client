// lib/features/home/repositories/home_repository.dart
import 'package:primero/features/home/data_sources/home_remote_data_source.dart';
import 'package:primero/features/home/models/character_info_model.dart';

class HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepository(this._remoteDataSource);

  Future<CharacterInfoModel> getCharacterInfo() {
    return _remoteDataSource.getCharacterInfo();
  }

  // --- ✨ 추가된 코드 ---
  Future<CharacterInfoModel> updateNickname(String nickname) {
    return _remoteDataSource.updateCharacterNickname(nickname: nickname);
  }

  Future<CharacterInfoModel> waterCharacter() {
    return _remoteDataSource.waterCharacter();
  }
}