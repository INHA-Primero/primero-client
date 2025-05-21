// lib/features/auth/data/models/email_verification_confirm_request_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'email_verification_confirm_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake) // verification_code
class EmailVerificationConfirmRequestModel {
  final String email;
  final String verificationCode;

  EmailVerificationConfirmRequestModel({
    required this.email,
    required this.verificationCode,
  });

  factory EmailVerificationConfirmRequestModel.fromJson(
    Map<String, dynamic> json,
  ) => _$EmailVerificationConfirmRequestModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$EmailVerificationConfirmRequestModelToJson(this);
}
