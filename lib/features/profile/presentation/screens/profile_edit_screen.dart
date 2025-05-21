// lib/features/profile/presentation/screens/profile_edit_screen.dart
import 'dart:io'; // File 사용을 위해 추가
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart'; // image_picker 추가
import 'package:primero/core/theme/app_colors.dart';
import 'package:primero/core/theme/app_text_style.dart';
import 'package:primero/features/profile/domain/entities/user_profile_entity.dart';
import 'package:primero/features/profile/presentation/providers/profile_di.dart';
import 'package:primero/features/profile/presentation/providers/profile_state.dart';
import 'package:primero/app/app_router.dart'; // AppRouteNames 사용 (경로 확인 필요)
import 'package:go_router/go_router.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  final UserProfileEntity initialProfile;
  const ProfileEditScreen({super.key, required this.initialProfile});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  late TextEditingController _nicknameController;
  final _formKey = GlobalKey<FormState>();

  File? _pickedImageFile; // 사용자가 갤러리에서 선택한 이미지 파일 (업로드 전 임시 저장)
  dynamic
  _displayImageSource; // 화면에 보여줄 이미지 소스 (File, String URL, 또는 String AssetPath)

  // 기본 프로필 이미지 에셋 경로
  static const String _defaultProfileAsset = 'assets/images/babyTree2.png';

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(
      text: widget.initialProfile.nickname,
    );
    // 초기 화면 표시용 이미지 소스 설정 (선택된 파일이 없으므로 URL 또는 기본 에셋 사용)
    _updateDisplayImageSource(
      newFile: null,
      newUrl: widget.initialProfile.profileImageUrl,
    );
  }

  /// 화면에 표시될 이미지 소스를 결정하고 UI를 업데이트합니다.
  void _updateDisplayImageSource({File? newFile, String? newUrl}) {
    setState(() {
      if (newFile != null) {
        _displayImageSource = newFile; // 사용자가 새로 선택한 파일 우선
      } else if (newUrl != null &&
          newUrl.isNotEmpty &&
          (newUrl.startsWith('http://') || newUrl.startsWith('https://'))) {
        _displayImageSource = newUrl; // 기존 네트워크 URL
      } else {
        _displayImageSource = _defaultProfileAsset; // 모두 없으면 기본 에셋 이미지
      }
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  /// 갤러리에서 이미지를 선택하고, 선택된 이미지를 상태에 반영하여 미리보기를 업데이트합니다.
  Future<void> _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      // 이미지 선택 옵션 (필요시 품질, 크기 제한 등 추가)
      // 예: final XFile? pickedXFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxHeight: 800);
      final XFile? pickedXFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedXFile != null) {
        _pickedImageFile = File(pickedXFile.path); // 업로드할 파일로 저장
        _updateDisplayImageSource(newFile: _pickedImageFile); // 화면 미리보기 업데이트
      }
    } catch (e) {
      print("Error picking image from gallery: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('갤러리에서 이미지를 가져오는 데 실패했습니다: ${e.toString()}')),
        );
      }
    }
  }

  /// 변경된 프로필 정보(닉네임 및/또는 이미지)를 서버에 저장(업데이트)하도록 Notifier에 요청합니다.
  void _submitUpdate() {
    // 현재 폼의 유효성 검사
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus(); // 키보드 숨기기

      final String newNickname = _nicknameController.text.trim();

      // ProfileNotifier의 updateProfileData 메서드 호출
      // _pickedImageFile이 null이면 이미지는 변경되지 않음 (서버에서 기존 이미지 유지 또는 삭제 처리)
      ref
          .read(profileNotifierProvider.notifier)
          .updateProfileData(
            newImageFile: _pickedImageFile,
            newNickname: newNickname,
          );
    }
  }

  /// 비밀번호 변경 화면으로 이동합니다.
  void _navigateToPasswordChangeScreen() {
    context.pushNamed(AppRouteNames.passwordChange);
  }

  /// 읽기 전용 정보 필드를 생성합니다.
  Widget _buildReadOnlyField(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        style: AppTextStyle.regular.copyWith(color: Colors.grey[800]),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyle.medium.copyWith(color: Colors.grey[600]),
          filled: true,
          fillColor: Colors.grey.shade200, // 읽기 전용 필드 배경색
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none, // 테두리 없음
          ),
          prefixIcon:
              icon != null
                  ? Icon(icon, color: Colors.grey[700], size: 20)
                  : null,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14.0,
            horizontal: 16.0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ProfileNotifier의 상태 변화를 감지하여 UI 피드백 (SnackBar 등) 처리
    ref.listen<ProfileState>(profileNotifierProvider, (previous, next) {
      if (next is ProfileInfoUpdateSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage),
            backgroundColor: AppColors.primary,
            duration: const Duration(seconds: 2),
          ),
        );
        // 업데이트 성공 시, 로컬에 임시 저장된 _pickedImageFile을 null로 초기화
        // 화면 표시는 Notifier에서 전달된 최신 UserProfileEntity의 이미지 URL로 업데이트
        _pickedImageFile = null;
        _updateDisplayImageSource(
          newFile: null,
          newUrl: next.userProfile.profileImageUrl,
        );
        _nicknameController.text =
            next.userProfile.nickname; // 닉네임도 최신 정보로 업데이트

        // (선택적) 성공 후 이전 화면으로 자동 이동
        // Future.delayed(const Duration(seconds: 1), () {
        //   if (mounted && context.canPop()) {
        //     context.pop();
        //   }
        // });
      } else if (next is ProfileInfoUpdateFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('프로필 업데이트 실패: ${next.errorMessage}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
        // 실패 시, 사용자가 입력/선택한 내용을 유지하여 재시도할 수 있도록 함
        // (또는 next.userProfile (실패 직전의 서버 데이터)로 UI를 복원할 수도 있음)
      }
    });

    final profileState = ref.watch(profileNotifierProvider);
    // 로딩 상태 결정 (프로필 최초 로딩 또는 전체 프로필 정보 업데이트 중)
    final bool isLoading =
        profileState is ProfileLoading || profileState is ProfileFullUpdating;

    // 화면에 표시될 프로필 엔티티 (업데이트 중에도 이전 데이터 보여주기 위함)
    // ProfileLoaded 상태이면서 ProfileFullUpdating이 아닐 때만 최신 데이터를 사용, 그 외에는 초기 데이터 사용
    final UserProfileEntity currentEffectiveProfile =
        (profileState is ProfileLoaded &&
                !(profileState is ProfileFullUpdating))
            ? profileState.userProfile
            : widget.initialProfile;

    // 화면에 표시될 이미지 프로바이더 결정
    ImageProvider displayImageProvider;
    if (_displayImageSource is File) {
      displayImageProvider = FileImage(
        _displayImageSource as File,
      ); // 선택된 로컬 파일
    } else if (_displayImageSource is String &&
        (_displayImageSource as String).startsWith('http')) {
      displayImageProvider = NetworkImage(
        _displayImageSource as String,
      ); // 네트워크 URL
    } else {
      displayImageProvider = const AssetImage(
        _defaultProfileAsset,
      ); // 기본 에셋 이미지
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('회원님의 정보를 입력해주세요!'),
        elevation: 0, // AppBar 그림자 제거
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, // 아이콘 및 텍스트 색상
        actions: [
          if (isLoading) // 로딩 중일 때 AppBar 오른쪽에 인디케이터 표시
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.primary,
                  ),
                ),
              ),
            )
          else // 로딩 중이 아닐 때 "저장" 버튼 표시
            TextButton(
              onPressed: _submitUpdate,
              child: Text(
                '저장',
                style: AppTextStyle.semiBold.copyWith(
                  color: AppColors.primary,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      backgroundColor: Colors.white, // 화면 전체 배경색
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, // 자식들을 중앙 정렬 (프로필 이미지 등)
            children: <Widget>[
              GestureDetector(
                onTap:
                    isLoading
                        ? null
                        : _pickImageFromGallery, // 로딩 중에는 이미지 변경 시도 비활성화
                child: Stack(
                  alignment: Alignment.bottomRight, // 카메라 아이콘을 우측 하단에 배치
                  children: [
                    CircleAvatar(
                      radius: 60, // 프로필 이미지 원의 반지름
                      backgroundColor: Colors.grey.shade200, // 이미지가 없을 때의 배경색
                      backgroundImage: displayImageProvider,
                      onBackgroundImageError: (exception, stackTrace) {
                        // 네트워크 이미지 로드 실패 시 기본 에셋 이미지로 대체
                        if (mounted &&
                            _displayImageSource is String &&
                            (_displayImageSource as String).startsWith(
                              'http',
                            )) {
                          _updateDisplayImageSource(
                            newFile: null,
                            newUrl: null,
                          ); // 기본 에셋으로 변경
                        }
                      },
                    ),
                    // 카메라 아이콘
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary, // 아이콘 배경색
                        shape: BoxShape.circle, // 원형 모양
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ), // 흰색 테두리
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32), // 이미지와 다음 필드 사이의 간격
              // 읽기 전용 필드들
              _buildReadOnlyField(
                "이름",
                currentEffectiveProfile.name,
                icon: Icons.person_outline,
              ),
              _buildReadOnlyField(
                "학번",
                currentEffectiveProfile.studentNumber,
                icon: Icons.school_outlined,
              ),
              _buildReadOnlyField(
                "이메일",
                currentEffectiveProfile.email,
                icon: Icons.email_outlined,
              ),
              _buildReadOnlyField(
                "총 포인트",
                "${currentEffectiveProfile.totalPoint} P",
                icon: Icons.star_outline,
              ),
              const SizedBox(height: 32),
              // 닉네임(나무 이름) 입력 필드
              TextFormField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  labelText: '나무 이름 (닉네임)',
                  border: const OutlineInputBorder(), // 일반적인 외곽선 테두리
                  prefixIcon: const Icon(Icons.eco_outlined), // 나무 아이콘
                  hintText: '새로운 나무 이름을 입력하세요',
                  labelStyle: AppTextStyle.medium,
                ),
                style: AppTextStyle.regular,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '나무 이름을 입력해주세요.';
                  }
                  // TODO: 닉네임 유효성 검사 규칙 추가 (예: 길이, 특수문자 제한 등)
                  // if (value.trim().length < 2) return '두 글자 이상 입력해주세요.';
                  return null;
                },
              ),
              const SizedBox(height: 32),
              // 비밀번호 변경 버튼
              SizedBox(
                width: double.infinity, // 버튼 너비를 화면 가로폭에 맞춤
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.lock_person_outlined, size: 20),
                  label: Text('비밀번호 변경', style: AppTextStyle.medium),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary.withOpacity(
                      0.1,
                    ), // 버튼 배경색 (약간 투명한 primary)
                    foregroundColor: AppColors.primary, // 버튼 글자/아이콘 색상
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 0, // 그림자 제거
                  ),
                  onPressed: _navigateToPasswordChangeScreen,
                ),
              ),
              const SizedBox(height: 20), // 하단 여백
            ],
          ),
        ),
      ),
    );
  }
}
