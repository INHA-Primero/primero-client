// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tree_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TreeModelImpl _$$TreeModelImplFromJson(Map<String, dynamic> json) =>
    _$TreeModelImpl(
      id: (json['id'] as num).toInt(),
      photoPath: json['photoPath'] as String?,
      pinColor: json['pinColor'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$$TreeModelImplToJson(_$TreeModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'photoPath': instance.photoPath,
      'pinColor': instance.pinColor,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
