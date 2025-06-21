// lib/features/home/data_sources/home_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:primero/features/home/models/character_info_model.dart';

part 'home_remote_data_source.g.dart';

@RestApi(baseUrl: "http://35.216.76.60:8080")
abstract class HomeRemoteDataSource {
  factory HomeRemoteDataSource(Dio dio, {String baseUrl}) =
      _HomeRemoteDataSource;

  // --- 기존 코드 ---
  @GET('/api/v1/characters/me')
  Future<CharacterInfoModel> getCharacterInfo();

  // --- ✨ 추가된 코드 ---
  @PUT('/api/v1/characters/me')
  Future<CharacterInfoModel> updateCharacterNickname({
    @Query("nickname") required String nickname,
  });

  @POST('/api/v1/characters/me/watering')
  Future<CharacterInfoModel> waterCharacter(); // 반환 타입을 CharacterInfoModel로 변경
}
