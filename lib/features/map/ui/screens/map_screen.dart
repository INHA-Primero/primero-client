import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Maps_flutter/Maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:primero/core/theme/app_colors.dart';

// TODO: 백엔드 API에서 받아올 나무 모델로 교체해야 합니다.
// swagger.json을 참고하여 Tree 모델을 만드세요.
// 예시:
// class Tree {
//   final int id;
//   final String name;
//   final double latitude;
//   final double longitude;
//
//   Tree({required this.id, required this.name, required this.latitude, required this.longitude});
// }

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final Set<Marker> _markers = {};

  // 초기 카메라 위치 (서울)
  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(37.5665, 126.9780),
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();
    _determinePositionAndLoadMarkers();
  }

  Future<void> _determinePositionAndLoadMarkers() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 위치 서비스 비활성화 시 처리
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('위치 서비스가 비활성화되었습니다. 활성화해주세요.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('위치 권한이 거부되었습니다.')));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('위치 권한이 영구적으로 거부되었습니다. 앱 설정에서 권한을 허용해주세요.'),
        ),
      );
      return;
    }

    // 현재 위치 가져오기
    Position position = await Geolocator.getCurrentPosition();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15.0,
        ),
      ),
    );

    // TODO: 여기에서 백엔드 API를 호출하여 나무 위치 데이터를 가져옵니다.
    // final treeRepository = ref.read(treeRepositoryProvider);
    // final List<Tree> userTrees = await treeRepository.getUserTrees();

    // API 호출 대신 더미 데이터를 사용합니다.
    final List<Map<String, dynamic>> dummyTrees = [
      {
        'id': 1,
        'name': '나의 첫번째 나무',
        'lat': position.latitude + 0.005,
        'lng': position.longitude + 0.005,
      },
      {
        'id': 2,
        'name': '나의 두번째 나무',
        'lat': position.latitude - 0.005,
        'lng': position.longitude - 0.005,
      },
      {'id': 3, 'name': '사무실 근처 나무', 'lat': 37.5013, 'lng': 127.0396}, // 강남역 근처
    ];

    _setMarkers(dummyTrees);
  }

  void _setMarkers(List<Map<String, dynamic>> trees) {
    setState(() {
      _markers.clear();
      for (final tree in trees) {
        final marker = Marker(
          markerId: MarkerId(tree['id'].toString()),
          position: LatLng(tree['lat'], tree['lng']),
          infoWindow: InfoWindow(
            title: tree['name'],
            snippet: '여기를 눌러 상세정보 보기',
            onTap: () {
              // TODO: 정보창 클릭 시 나무 상세 화면으로 이동
            },
          ),
        );
        _markers.add(marker);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 나무 지도'),
        backgroundColor: AppColors.primary,
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kInitialPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: _markers,
      ),
    );
  }
}
