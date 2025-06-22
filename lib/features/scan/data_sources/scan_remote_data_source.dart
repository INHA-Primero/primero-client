// lib/features/scan/data_sources/scan_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'scan_remote_data_source.g.dart';

@RestApi(baseUrl: "http://35.216.76.60:8080")
abstract class ScanRemoteDataSource {
  // ✨ 수정: errorLogger 파라미터 제거
  factory ScanRemoteDataSource(Dio dio, {String baseUrl}) =
      _ScanRemoteDataSource;

  @POST('/api/barcode/log')
  @MultiPart()
  Future<void> logScanResult({
    @Query("code") required String code,
    @Query("success") required bool success,
    @Query("location") required String location,
  });
}
