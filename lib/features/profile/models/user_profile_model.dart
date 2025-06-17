import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'user_profile_model.g.dart';

@JsonSerializable()
class UserProfileModel extends Equatable {
  final int userId;
  final String email;
  final String name;
  final int studentNumber;
  final String treeName; // 기존 nickname을 treeName으로 변경
  final String? profileImgPath; // 기존 profileImageUrl을 profileImgPath로 변경
  final int totalPoint;

  const UserProfileModel({
    required this.userId,
    required this.email,
    required this.name,
    required this.studentNumber,
    required this.treeName,
    this.profileImgPath,
    required this.totalPoint,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);

  @override
  List<Object?> get props => [
    userId,
    email,
    name,
    studentNumber,
    treeName,
    profileImgPath,
    totalPoint,
  ];
}
