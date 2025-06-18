import '../data_sources/scan_remote_data_source.dart';

class ScanRepository {
  final ScanRemoteDataSource _remoteDataSource;

  ScanRepository(this._remoteDataSource);

  Future<void> logScanResult({
    required String barcode,
    required bool success,
    required String location,
  }) {
    return _remoteDataSource.logScanResult(
      code: barcode,
      success: success,
      location: location,
    );
  }
}
