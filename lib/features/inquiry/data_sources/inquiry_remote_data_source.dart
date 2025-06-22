import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/inquiry_request.dart';
import '../models/inquiry_response.dart';
import '../models/page_inquiry_response.dart';

part 'inquiry_remote_data_source.g.dart';

@RestApi(baseUrl: "http://35.216.76.60:8080")
abstract class InquiryRemoteDataSource {
  factory InquiryRemoteDataSource(Dio dio, {String baseUrl}) =
      _InquiryRemoteDataSource;

  @GET('/api/inquiry/me')
  Future<PageInquiryResponse> getMyInquiries(
    @Query("page") int page,
    @Query("size") int size,
  );

  @GET('/api/inquiry/{inquiryId}')
  Future<InquiryResponse> getInquiryDetail(@Path('inquiryId') int inquiryId);

  @POST('/api/inquiry')
  Future<InquiryResponse> createInquiry(@Body() InquiryRequest request);
}
