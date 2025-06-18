import 'package:json_annotation/json_annotation.dart';

part 'signup_request_model.g.dart';

@JsonSerializable()
class SignupRequestModel {
  final String name;
  final int studentNumber;
  final String treeName;
  final String email;
  final String password;
  final String confirmPassword;
  final String deviceUuid;

  SignupRequestModel({
    required this.name,
    required this.studentNumber,
    required this.treeName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.deviceUuid,
  });

  factory SignupRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SignupRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignupRequestModelToJson(this);
}
