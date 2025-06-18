// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inquiry_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InquiryRequest _$InquiryRequestFromJson(Map<String, dynamic> json) =>
    InquiryRequest(
      title: json['title'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$InquiryRequestToJson(InquiryRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
    };
