import 'package:freezed_annotation/freezed_annotation.dart';

part 'recycle_history_model.freezed.dart';
part 'recycle_history_model.g.dart';

// 분리수거 기록 페이지네이션 응답 모델
// API: GET /api/v1/recycles
@freezed
class PageRecycleListResponse with _$PageRecycleListResponse {
  const factory PageRecycleListResponse({
    required int totalPages,
    required int totalElements,
    required bool first,
    required bool last,
    required int size,
    required List<RecycleListItem> content,
    required int number,
    required int numberOfElements,
    required bool empty,
  }) = _PageRecycleListResponse;

  factory PageRecycleListResponse.fromJson(Map<String, dynamic> json) =>
      _$PageRecycleListResponseFromJson(json);
}

// 분리수거 기록 리스트의 각 아이템 모델
@freezed
class RecycleListItem with _$RecycleListItem {
  const factory RecycleListItem({
    required int id,
    required bool result,
    required DateTime takenAt,
    required String binLocation,
  }) = _RecycleListItem;

  factory RecycleListItem.fromJson(Map<String, dynamic> json) =>
      _$RecycleListItemFromJson(json);
}

// 분리수거 기록 상세 정보 응답 모델
// API: GET /api/v1/recycles/{id}
@freezed
class RecycleDetail with _$RecycleDetail {
  const factory RecycleDetail({
    required int id,
    required bool result,
    required DateTime takenAt,
    required String binLocation,
    required String recordImgPath,
  }) = _RecycleDetail;

  factory RecycleDetail.fromJson(Map<String, dynamic> json) =>
      _$RecycleDetailFromJson(json);
}
