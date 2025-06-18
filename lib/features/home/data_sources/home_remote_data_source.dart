import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:primero/features/home/models/character_info_model.dart';

part 'home_remote_data_source.g.dart';

// 캐릭터 정보를 가져오는 가상의 API 엔드포인트를 정의합니다.
@RestApi(baseUrl: "http://localhost:8080")
abstract class HomeRemoteDataSource {
  factory HomeRemoteDataSource(Dio dio, {String baseUrl}) =
      _HomeRemoteDataSource;

  @GET('/api/character/me')
  Future<CharacterInfoModel> getCharacterInfo();
}
