import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:primero/features/tree_map/providers/tree_map_di.dart';

// 팝업 정보를 담을 간단한 클래스
class PopupInfo {
  final String markerId;
  final Offset position;
  PopupInfo({required this.markerId, required this.position});
}

class TreeMapScreen extends ConsumerStatefulWidget {
  const TreeMapScreen({super.key});

  @override
  ConsumerState<TreeMapScreen> createState() => _TreeMapScreenState();
}

class _TreeMapScreenState extends ConsumerState<TreeMapScreen> {
  PopupInfo? _popupInfo;
  String? _pendingPopupMarkerId;

  // ✨ 문제 해결: onTap에서 직접 팝업을 띄우는 함수 추가
  Future<void> _showPopupForMarker(String markerId) async {
    final notifier = ref.read(treeMapNotifierProvider.notifier);
    final mapState = ref.read(treeMapNotifierProvider);

    // markerId에 해당하는 tree 정보 찾기
    final tree = mapState.myTrees.firstWhere(
      (t) => t.id.toString() == markerId,
    );

    // 화면 좌표 얻기
    final screenPosition = await notifier.mapController?.getScreenCoordinate(
      LatLng(tree.latitude, tree.longitude),
    );

    if (screenPosition != null) {
      setState(() {
        _popupInfo = PopupInfo(
          markerId: markerId,
          position: Offset(
            screenPosition.x.toDouble(),
            screenPosition.y.toDouble(),
          ),
        );
        _pendingPopupMarkerId = null; // 처리 완료 후 초기화
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(treeMapNotifierProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(treeMapNotifierProvider);
    final notifier = ref.read(treeMapNotifierProvider.notifier);

    final screenWidth = MediaQuery.of(context).size.width;
    final popupWidth = screenWidth - 40;
    final popupHeight = popupWidth * 0.9;

    Set<Marker> markers =
        mapState.myTrees.map((tree) {
          final markerId = MarkerId(tree.id.toString());
          return Marker(
            markerId: markerId,
            position: LatLng(tree.latitude, tree.longitude),
            onTap: () {
              setState(() {
                _popupInfo = null;
                _pendingPopupMarkerId = markerId.value;
              });
              // ✨ 문제 해결: 카메라 이동과 함께 팝업 표시 함수를 바로 호출할 수 있도록 약간의 지연을 줌
              notifier.mapController?.animateCamera(
                CameraUpdate.newLatLng(LatLng(tree.latitude, tree.longitude)),
              );
              // 카메라가 움직이지 않는 경우를 대비해, 여기서 직접 팝업을 띄우도록 타이머 설정
              Timer(const Duration(milliseconds: 100), () {
                if (_pendingPopupMarkerId == markerId.value) {
                  _showPopupForMarker(markerId.value);
                }
              });
            },
          );
        }).toSet();

    return Scaffold(
      appBar: AppBar(title: const Text('내 나무 지도'), centerTitle: true),
      body: Builder(
        builder: (context) {
          if (mapState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (mapState.errorMessage != null) {
            return Center(child: Text('에러: ${mapState.errorMessage}'));
          }
          if (mapState.myTrees.isEmpty) {
            return const Center(
              child: Text('아직 생성된 나무가 없습니다!', style: TextStyle(fontSize: 18)),
            );
          }

          return Stack(
            children: [
              GoogleMap(
                onMapCreated: (controller) {
                  notifier.mapController = controller;
                  notifier.moveCameraToFitTrees();
                },
                onCameraIdle: () async {
                  // 카메라 이동이 끝났을 때만 팝업 위치 재계산
                  if (_pendingPopupMarkerId != null) {
                    await _showPopupForMarker(_pendingPopupMarkerId!);
                  }
                },
                initialCameraPosition: CameraPosition(
                  target:
                      mapState.currentPosition ??
                      const LatLng(37.5665, 126.9780),
                  zoom: 15,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                markers: markers,
                onTap: (_) {
                  if (_popupInfo != null) {
                    setState(() {
                      _popupInfo = null;
                    });
                  }
                },
              ),
              if (_popupInfo != null)
                Positioned(
                  left: _popupInfo!.position.dx - (popupWidth / 2),
                  top: _popupInfo!.position.dy - popupHeight - 15,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _popupInfo = null;
                      });
                    },
                    child: Material(
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: popupWidth,
                        height: popupHeight,
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '나무 #${_popupInfo!.markerId}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'assets/images/real_tree.png', // pubspec.yaml에 등록된 내부 이미지 사용
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
