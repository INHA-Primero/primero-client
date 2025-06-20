import 'package:freezed_annotation/freezed_annotation.dart';

part 'tree_model.freezed.dart';
part 'tree_model.g.dart';

// swagger의 TreeResponse 스키마를 기반으로 생성
@freezed
class TreeModel with _$TreeModel {
  const factory TreeModel({
    required int id,
    String? photoPath,
    String? pinColor,
    required double latitude,
    required double longitude,
  }) = _TreeModel;

  // 이 부분을 수정했습니다.
  // build_runner가 생성하는 fromJson 팩토리 생성자를 사용합니다.
  factory TreeModel.fromJson(Map<String, dynamic> json) =>
      _$TreeModelFromJson(json);
}
