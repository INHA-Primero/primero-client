// lib/features/profile/models/auth_log_res.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_log_res.freezed.dart';
part 'auth_log_res.g.dart';

@freezed
class AuthLogRes with _$AuthLogRes {
  const factory AuthLogRes({
    required String date,
    required String time,
    required String location,
    required bool success,
    String? imagePath,
  }) = _AuthLogRes;

  factory AuthLogRes.fromJson(Map<String, dynamic> json) =>
      _$AuthLogResFromJson(json);
}
