// lib/features/auth/data/models/signup_request_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'signup_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake) // student_number, device_uuid
class SignupRequestModel {
  final String email;
  final String password;
  final String name;
  final String studentNumber; // API 명세에는 int로 되어있으나, 문자열로 처리 후 서버에서 변환하는 것이 일반적
  final String nickname;
  final String deviceUuid;

  SignupRequestModel({
    required this.email,
    required this.password,
    required this.name,
    required this.studentNumber,
    required this.nickname,
    required this.deviceUuid,
  });

  factory SignupRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SignupRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$SignupRequestModelToJson(this);
}
