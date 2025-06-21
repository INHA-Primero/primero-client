import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:primero/features/tree_map/models/tree_model.dart';
import 'package:primero/features/tree_map/providers/tree_map_state.dart';
import 'package:primero/features/tree_map/repositories/tree_map_repository.dart';

class TreeMapNotifier extends StateNotifier<TreeMapState> {
  final TreeMapRepository _repository;
  TreeMapNotifier(this._repository) : super(const TreeMapState());

  GoogleMapController? mapController;

  Future<void> initialize() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final position = await _determinePosition();
      final currentLatLng = LatLng(position.latitude, position.longitude);

      final userId = await _repository.getMyUserId();
      if (userId == null) throw Exception("User not logged in.");

      // 서버에서 내 나무 목록을 가져옵니다.
      // 이 결과가 비어있는지 아닌지는 UI에서 판단합니다.
      final trees = await _repository.getMyTrees(userId);

      state = state.copyWith(
        isLoading: false,
        currentPosition: currentLatLng,
        myTrees: trees,
      );

      // 나무가 있을 때만 카메라 이동
      if (trees.isNotEmpty) {
        moveCameraToFitTrees();
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      print('[TreeMapNotifier] Error: ${e.toString()}');
    }
  }

  void moveCameraToFitTrees() {
    if (mapController == null || state.myTrees.isEmpty) return;

    if (state.myTrees.length == 1) {
      final position = state.myTrees.first;
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          15.0,
        ),
      );
    } else {
      final bounds = _boundsFromLatLngList(
        state.myTrees.map((t) => LatLng(t.latitude, t.longitude)).toList(),
      );
      mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50.0));
    }
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0!) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
      northeast: LatLng(x1!, y1!),
      southwest: LatLng(x0!, y0!),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Location services are disabled.');

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
