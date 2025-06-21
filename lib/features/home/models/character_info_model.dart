// lib/features/home/models/character_info_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'character_info_model.freezed.dart';
part 'character_info_model.g.dart';

@freezed
class CharacterInfoModel with _$CharacterInfoModel {
  const factory CharacterInfoModel({
    // 🔴 [수정] swagger.json에 명시된 필드명과 타입, 기본값을 정확히 일치시킵니다.
    // 불필요한 characterId, createdAt, lastModifiedAt 필드를 삭제합니다.
    @JsonKey(name: 'exp', defaultValue: 0) @Default(0) int exp,
    @JsonKey(name: 'wateringChance', defaultValue: 0) @Default(0) int wateringChance,
    @JsonKey(name: 'nickname', defaultValue: '새싹') required String nickname,
  }) = _CharacterInfoModel;

  factory CharacterInfoModel.fromJson(Map<String, dynamic> json) =>
      _$CharacterInfoModelFromJson(json);
}