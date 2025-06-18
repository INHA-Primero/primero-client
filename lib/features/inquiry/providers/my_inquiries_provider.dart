import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/page_inquiry_response.dart';
import '../repositories/inquiry_repository.dart';

class MyInquiriesNotifier
    extends StateNotifier<AsyncValue<PageInquiryResponse>> {
  final InquiryRepository _repository;

  MyInquiriesNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchInquiries();
  }

  Future<void> fetchInquiries() async {
    state = const AsyncValue.loading();
    try {
      final inquiries = await _repository.getMyInquiries();
      state = AsyncValue.data(inquiries);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}
