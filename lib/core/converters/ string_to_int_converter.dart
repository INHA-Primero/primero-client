import 'package:freezed_annotation/freezed_annotation.dart';

// 서버에서 String으로 오는 값을 int로 변환하기 위한 JsonConverter
class StringToIntConverter implements JsonConverter<int, Object> {
  const StringToIntConverter();

  // JSON 데이터를 Dart 객체로 변환할 때 (서버 -> 앱)
  @override
  int fromJson(Object json) {
    if (json is int) {
      return json;
    }
    if (json is String) {
      return int.tryParse(json) ?? 0; // 문자열을 int로 변환, 실패 시 0 반환
    }
    // 예상치 못한 타입일 경우 기본값 0 반환
    return 0;
  }

  // Dart 객체를 JSON 데이터로 변환할 때 (앱 -> 서버)
  @override
  Object toJson(int object) => object.toString();
}
