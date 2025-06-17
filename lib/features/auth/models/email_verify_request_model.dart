import 'package:json_annotation/json_annotation.dart';

part 'email_verify_request_model.g.dart';

@JsonSerializable()
class EmailVerifyRequestModel {
  final String email;
  final String code;

  EmailVerifyRequestModel({required this.email, required this.code});

  factory EmailVerifyRequestModel.fromJson(Map<String, dynamic> json) =>
      _$EmailVerifyRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmailVerifyRequestModelToJson(this);
}
