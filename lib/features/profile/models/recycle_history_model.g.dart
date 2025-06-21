// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recycle_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PageRecycleListResponseImpl _$$PageRecycleListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PageRecycleListResponseImpl(
      totalPages: (json['totalPages'] as num).toInt(),
      totalElements: (json['totalElements'] as num).toInt(),
      first: json['first'] as bool,
      last: json['last'] as bool,
      size: (json['size'] as num).toInt(),
      content: (json['content'] as List<dynamic>)
          .map((e) => RecycleListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      number: (json['number'] as num).toInt(),
      numberOfElements: (json['numberOfElements'] as num).toInt(),
      empty: json['empty'] as bool,
    );

Map<String, dynamic> _$$PageRecycleListResponseImplToJson(
        _$PageRecycleListResponseImpl instance) =>
    <String, dynamic>{
      'totalPages': instance.totalPages,
      'totalElements': instance.totalElements,
      'first': instance.first,
      'last': instance.last,
      'size': instance.size,
      'content': instance.content,
      'number': instance.number,
      'numberOfElements': instance.numberOfElements,
      'empty': instance.empty,
    };

_$RecycleListItemImpl _$$RecycleListItemImplFromJson(
        Map<String, dynamic> json) =>
    _$RecycleListItemImpl(
      id: (json['id'] as num).toInt(),
      result: json['result'] as bool,
      takenAt: DateTime.parse(json['takenAt'] as String),
      binLocation: json['binLocation'] as String,
    );

Map<String, dynamic> _$$RecycleListItemImplToJson(
        _$RecycleListItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'result': instance.result,
      'takenAt': instance.takenAt.toIso8601String(),
      'binLocation': instance.binLocation,
    };

_$RecycleDetailImpl _$$RecycleDetailImplFromJson(Map<String, dynamic> json) =>
    _$RecycleDetailImpl(
      id: (json['id'] as num).toInt(),
      result: json['result'] as bool,
      takenAt: DateTime.parse(json['takenAt'] as String),
      binLocation: json['binLocation'] as String,
      recordImgPath: json['recordImgPath'] as String,
    );

Map<String, dynamic> _$$RecycleDetailImplToJson(_$RecycleDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'result': instance.result,
      'takenAt': instance.takenAt.toIso8601String(),
      'binLocation': instance.binLocation,
      'recordImgPath': instance.recordImgPath,
    };
