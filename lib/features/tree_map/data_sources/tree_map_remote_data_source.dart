import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:primero/features/tree_map/models/tree_model.dart';

part 'tree_map_remote_data_source.g.dart';

// HomeRemoteDataSource와 동일한 방식으로 baseUrl을 여기에 명시합니다.
@RestApi(baseUrl: "http://35.216.76.60:8080")
abstract class TreeMapRemoteDataSource {
  factory TreeMapRemoteDataSource(Dio dio, {String baseUrl}) =
      _TreeMapRemoteDataSource;

  // @GET 어노테이션에 '/api'를 포함한 전체 경로를 넣어줍니다.
  @GET('/api/tree/{userId}')
  Future<List<TreeModel>> getMyTrees(@Path('userId') int userId);
}
