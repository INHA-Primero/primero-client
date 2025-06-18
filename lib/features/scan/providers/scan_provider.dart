import 'package:riverpod/riverpod.dart';
import 'package:primero/features/auth/providers/auth_di.dart';
import '../data_sources/scan_remote_data_source.dart';
import '../repositories/scan_repository.dart';

final scanRemoteDataSourceProvider = Provider<ScanRemoteDataSource>((ref) {
  return ScanRemoteDataSource(ref.watch(dioProvider));
});

final scanRepositoryProvider = Provider<ScanRepository>((ref) {
  return ScanRepository(ref.watch(scanRemoteDataSourceProvider));
});

// 스캔 화면의 현재 상태 (바코드/대기/성공/실패)
enum ScanStatus { idle, processing, success, failure }

// 상태를 관리하는 프로바이더
final scanStatusProvider = StateProvider<ScanStatus>((ref) => ScanStatus.idle);
