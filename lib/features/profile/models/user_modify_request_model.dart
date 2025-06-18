import 'package:json_annotation/json_annotation.dart';

part 'user_modify_request_model.g.dart';

@JsonSerializable()
class UserModifyRequestModel {
  final String treeName;
  final String? password;
  final String? profileImgPath; // 이미지 경로를 다시 포함합니다.

  UserModifyRequestModel({
    required this.treeName,
    this.password,
    this.profileImgPath,
  });

  factory UserModifyRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UserModifyRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModifyRequestModelToJson(this);
}
