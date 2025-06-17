import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel extends Equatable {
  final int userId;
  final String treeName;
  final String token;

  const LoginResponseModel({
    required this.userId,
    required this.treeName,
    required this.token,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);

  @override
  List<Object> get props => [userId, treeName, token];
}
