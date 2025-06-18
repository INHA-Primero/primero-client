// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inquiry_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InquiryResponseImpl _$$InquiryResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$InquiryResponseImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      status: json['status'] as String,
      writer: json['writer'] as String,
      answers: (json['answers'] as List<dynamic>)
          .map((e) => AnswerResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String,
      lastModifiedAt: json['lastModifiedAt'] as String,
    );

Map<String, dynamic> _$$InquiryResponseImplToJson(
        _$InquiryResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'status': instance.status,
      'writer': instance.writer,
      'answers': instance.answers,
      'createdAt': instance.createdAt,
      'lastModifiedAt': instance.lastModifiedAt,
    };

_$AnswerResponseImpl _$$AnswerResponseImplFromJson(Map<String, dynamic> json) =>
    _$AnswerResponseImpl(
      id: (json['id'] as num).toInt(),
      content: json['content'] as String,
      createdAt: json['createdAt'] as String,
      lastModifiedAt: json['lastModifiedAt'] as String,
    );

Map<String, dynamic> _$$AnswerResponseImplToJson(
        _$AnswerResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'createdAt': instance.createdAt,
      'lastModifiedAt': instance.lastModifiedAt,
    };
