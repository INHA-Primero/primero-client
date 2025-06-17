import 'package:json_annotation/json_annotation.dart';

part 'email_send_request_model.g.dart';

@JsonSerializable()
class EmailSendRequestModel {
  final String email;

  EmailSendRequestModel({required this.email});

  factory EmailSendRequestModel.fromJson(Map<String, dynamic> json) =>
      _$EmailSendRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmailSendRequestModelToJson(this);
}
