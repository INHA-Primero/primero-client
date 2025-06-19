// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_inquiry_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageInquiryResponse _$PageInquiryResponseFromJson(Map<String, dynamic> json) =>
    PageInquiryResponse(
      content: (json['content'] as List<dynamic>)
          .map((e) => InquiryResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: (json['totalPages'] as num).toInt(),
      totalElements: (json['totalElements'] as num).toInt(),
      last: json['last'] as bool,
      size: (json['size'] as num).toInt(),
      number: (json['number'] as num).toInt(),
      numberOfElements: (json['numberOfElements'] as num).toInt(),
      first: json['first'] as bool,
      empty: json['empty'] as bool,
    );

Map<String, dynamic> _$PageInquiryResponseToJson(
        PageInquiryResponse instance) =>
    <String, dynamic>{
      'content': instance.content,
      'totalPages': instance.totalPages,
      'totalElements': instance.totalElements,
      'last': instance.last,
      'size': instance.size,
      'number': instance.number,
      'numberOfElements': instance.numberOfElements,
      'first': instance.first,
      'empty': instance.empty,
    };
