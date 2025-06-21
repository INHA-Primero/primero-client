import 'package:freezed_annotation/freezed_annotation.dart';
import 'inquiry_response.dart';

part 'page_inquiry_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class PageInquiryResponse {
  final List<InquiryResponse> content;
  final int totalPages;
  final int totalElements;
  final bool last;
  final int size;
  final int number; // current page number
  final int numberOfElements;
  final bool first;
  final bool empty;

  PageInquiryResponse({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.last,
    required this.size,
    required this.number,
    required this.numberOfElements,
    required this.first,
    required this.empty,
  });

  factory PageInquiryResponse.fromJson(Map<String, dynamic> json) =>
      _$PageInquiryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PageInquiryResponseToJson(this);
}
