// lib/features/auth/data/models/signup_request_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'signup_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SignupRequestModel {
  final String email;
  final String password;
  final String name;
  final String studentNumber;
  final String nickname;
  // deviceUuid 필드는 헤더로 전송되므로 모델에서 제거합니다.

  SignupRequestModel({
    required this.email,
    required this.password,
    required this.name,
    required this.studentNumber,
    required this.nickname,
  });

  factory SignupRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SignupRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$SignupRequestModelToJson(this);
}
