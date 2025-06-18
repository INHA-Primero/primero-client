// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CharacterInfoModelImpl _$$CharacterInfoModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CharacterInfoModelImpl(
      characterId: (json['characterId'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      exp: (json['exp'] as num).toInt(),
      wateringChance: (json['wateringChance'] as num).toInt(),
      nickname: json['nickname'] as String,
    );

Map<String, dynamic> _$$CharacterInfoModelImplToJson(
        _$CharacterInfoModelImpl instance) =>
    <String, dynamic>{
      'characterId': instance.characterId,
      'userId': instance.userId,
      'exp': instance.exp,
      'wateringChance': instance.wateringChance,
      'nickname': instance.nickname,
    };
