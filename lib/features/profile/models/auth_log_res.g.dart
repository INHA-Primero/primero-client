// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_log_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthLogResImpl _$$AuthLogResImplFromJson(Map<String, dynamic> json) =>
    _$AuthLogResImpl(
      date: json['date'] as String,
      time: json['time'] as String,
      location: json['location'] as String,
      success: json['success'] as bool,
      imagePath: json['imagePath'] as String?,
    );

Map<String, dynamic> _$$AuthLogResImplToJson(_$AuthLogResImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'time': instance.time,
      'location': instance.location,
      'success': instance.success,
      'imagePath': instance.imagePath,
    };
