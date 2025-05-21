// lib/features/auth/data/models/login_request_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'login_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake) // device_uuid
class LoginRequestModel {
  final String email;
  final String password;
  final String deviceUuid;

  LoginRequestModel({
    required this.email,
    required this.password,
    required this.deviceUuid,
  });

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestModelToJson(this);
}
