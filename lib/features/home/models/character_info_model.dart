import 'package:freezed_annotation/freezed_annotation.dart';

part 'character_info_model.freezed.dart';
part 'character_info_model.g.dart';

// API 응답을 가정한 캐릭터 정보 모델입니다. (두 번째 이미지 참고)
@freezed
class CharacterInfoModel with _$CharacterInfoModel {
  const factory CharacterInfoModel({
    required int characterId,
    required int userId,
    required int exp,
    required int wateringChance,
    required String nickname,
  }) = _CharacterInfoModel;

  factory CharacterInfoModel.fromJson(Map<String, dynamic> json) =>
      _$CharacterInfoModelFromJson(json);
}
