// lib/features/profile/domain/usecases/upload_profile_image_usecase.dart
import 'dart:io';
import 'package:primero/features/profile/domain/repositories/profile_repository.dart';

class UploadProfileImageUseCase {
  final ProfileRepository repository;

  UploadProfileImageUseCase(this.repository);

  Future<String> call(File imageFile) async {
    // 이미지 파일 유효성 검사 (예: 크기, 확장자 등)
    // 예시: 5MB 이하의 이미지만 허용
    const int maxSizeInBytes = 5 * 1024 * 1024; // 5MB
    if (await imageFile.length() > maxSizeInBytes) {
      throw Exception("이미지 파일 크기는 5MB를 초과할 수 없습니다.");
    }
    // TODO: 필요한 경우 이미지 확장자 검사 로직 추가

    try {
      // Repository를 통해 이미지 업로드 요청
      return await repository.uploadProfileImage(imageFile);
    } catch (e) {
      // 유스케이스 레벨에서 특정 에러를 잡아서 다른 형태로 변환하거나,
      // 로깅 등의 추가 작업을 수행할 수 있습니다.
      print('Error in UploadProfileImageUseCase: $e');
      throw Exception('이미지 업로드 처리 중 오류가 발생했습니다.');
    }
  }
}
