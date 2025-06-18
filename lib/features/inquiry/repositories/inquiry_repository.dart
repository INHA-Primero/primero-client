// lib/features/inquiry/repositories/inquiry_repository.dart
import '../data_sources/inquiry_remote_data_source.dart';
import '../models/inquiry_request.dart';
import '../models/inquiry_response.dart'; // 상세보기에 InquiryResponse 사용
import '../models/page_inquiry_response.dart';

class InquiryRepository {
  final InquiryRemoteDataSource _remoteDataSource;
  InquiryRepository(this._remoteDataSource);

  Future<PageInquiryResponse> getMyInquiries({int page = 0, int size = 10}) {
    return _remoteDataSource.getMyInquiries(page, size);
  }

  // ✨ 상세 정보를 가져오는 메서드 추가
  Future<InquiryResponse> getInquiryDetail(int inquiryId) {
    return _remoteDataSource.getInquiryDetail(inquiryId);
  }

  Future<InquiryResponse> createInquiry({
    required String title,
    required String content,
  }) {
    final request = InquiryRequest(title: title, content: content);
    return _remoteDataSource.createInquiry(request);
  }
}
