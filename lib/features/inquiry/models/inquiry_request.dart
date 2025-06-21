import 'package:json_annotation/json_annotation.dart';

part 'inquiry_request.g.dart';

@JsonSerializable()
class InquiryRequest {
  final String title;
  final String content;

  InquiryRequest({required this.title, required this.content});

  factory InquiryRequest.fromJson(Map<String, dynamic> json) =>
      _$InquiryRequestFromJson(json);

  Map<String, dynamic> toJson() => _$InquiryRequestToJson(this);
}
