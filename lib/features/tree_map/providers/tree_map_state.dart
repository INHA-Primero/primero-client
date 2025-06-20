import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:primero/features/tree_map/models/tree_model.dart';

part 'tree_map_state.freezed.dart';

@freezed
class TreeMapState with _$TreeMapState {
  const factory TreeMapState({
    @Default(true) bool isLoading,
    LatLng? currentPosition,
    @Default({}) Set<Marker> markers,
    @Default([]) List<TreeModel> myTrees,
    String? errorMessage,
  }) = _TreeMapState;
}
