import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/features/auth/providers/auth_di.dart';
import '../data_sources/inquiry_remote_data_source.dart';
import '../repositories/inquiry_repository.dart';
import '../providers/my_inquiries_provider.dart';
import '../models/page_inquiry_response.dart';
import '../models/inquiry_response.dart'; // 상세보기에 InquiryResponse 사용

final inquiryRemoteDataSourceProvider = Provider<InquiryRemoteDataSource>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return InquiryRemoteDataSource(dio);
});

final inquiryRepositoryProvider = Provider<InquiryRepository>((ref) {
  final remoteDataSource = ref.watch(inquiryRemoteDataSourceProvider);
  return InquiryRepository(remoteDataSource);
});

final myInquiriesProvider = StateNotifierProvider.autoDispose<
  MyInquiriesNotifier,
  AsyncValue<PageInquiryResponse>
>((ref) {
  return MyInquiriesNotifier(ref.watch(inquiryRepositoryProvider));
});
final inquiryDetailProvider = FutureProvider.autoDispose
    .family<InquiryResponse, int>((ref, inquiryId) {
      final inquiryRepository = ref.watch(inquiryRepositoryProvider);
      return inquiryRepository.getInquiryDetail(inquiryId);
    });
