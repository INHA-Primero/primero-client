import 'package:freezed_annotation/freezed_annotation.dart';

part 'inquiry_response.freezed.dart';
part 'inquiry_response.g.dart';

@freezed
class InquiryResponse with _$InquiryResponse {
  const factory InquiryResponse({
    required int id,
    required String title,
    required String content,
    required String status,
    required String writer,
    required List<AnswerResponse> answers,
    required String createdAt,
    required String lastModifiedAt,
  }) = _InquiryResponse;

  factory InquiryResponse.fromJson(Map<String, dynamic> json) =>
      _$InquiryResponseFromJson(json);
}

@freezed
class AnswerResponse with _$AnswerResponse {
  const factory AnswerResponse({
    required int id,
    required String content,
    required String createdAt,
    required String lastModifiedAt,
  }) = _AnswerResponse;

  factory AnswerResponse.fromJson(Map<String, dynamic> json) =>
      _$AnswerResponseFromJson(json);
}
