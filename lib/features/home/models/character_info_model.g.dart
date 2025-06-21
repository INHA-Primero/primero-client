// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CharacterInfoModelImpl _$$CharacterInfoModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CharacterInfoModelImpl(
      exp: (json['exp'] as num?)?.toInt() ?? 0,
      wateringChance: (json['wateringChance'] as num?)?.toInt() ?? 0,
      nickname: json['nickname'] as String? ?? '새싹',
    );

Map<String, dynamic> _$$CharacterInfoModelImplToJson(
        _$CharacterInfoModelImpl instance) =>
    <String, dynamic>{
      'exp': instance.exp,
      'wateringChance': instance.wateringChance,
      'nickname': instance.nickname,
    };
