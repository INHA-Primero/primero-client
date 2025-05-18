// lib/features/profile/presentation/screens/profile_edit_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/core/theme/app_colors.dart';
import 'package:primero/core/theme/app_text_style.dart';
import 'package:primero/features/profile/domain/entities/user_profile_entity.dart';
import 'package:primero/features/profile/presentation/providers/profile_di.dart';
import 'package:primero/features/profile/presentation/providers/profile_state.dart';
import 'package:primero/app/app_router.dart';
import 'package:go_router/go_router.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  final UserProfileEntity initialProfile;
  const ProfileEditScreen({super.key, required this.initialProfile});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  late TextEditingController _nicknameController;
  late TextEditingController _profileImageUrlController;
  final _formKey = GlobalKey<FormState>();

  // 기본 프로필 이미지 경로
  static const String _defaultProfileAsset = 'assets/images/babyTree2.png';
  // 현재 화면에 표시될 이미지 (네트워크 URL 또는 로컬 에셋 경로)
  String _currentDisplayImageSource = '';

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(
      text: widget.initialProfile.nickname,
    );
    _profileImageUrlController = TextEditingController(
      text: widget.initialProfile.profileImageUrl ?? '',
    );
    // 초기 표시 이미지 설정
    _updateCurrentDisplayImageSource(widget.initialProfile.profileImageUrl);
  }

  void _updateCurrentDisplayImageSource(String? newUrl) {
    setState(() {
      if (newUrl != null &&
          newUrl.isNotEmpty &&
          (newUrl.startsWith('http://') || newUrl.startsWith('https://'))) {
        _currentDisplayImageSource = newUrl;
      } else {
        _currentDisplayImageSource = _defaultProfileAsset;
      }
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _profileImageUrlController.dispose();
    super.dispose();
  }

  void _submitUpdate() {
    if (_formKey.currentState!.validate()) {
      String? imageUrlToSave = _profileImageUrlController.text.trim();
      if (imageUrlToSave.isEmpty || imageUrlToSave == _defaultProfileAsset) {
        // 사용자가 URL을 지웠거나 기본 이미지 경로가 입력된 경우, null로 처리하여 서버에 이미지 없음을 알림
        // (서버 API가 빈 문자열을 null로 처리하거나, null을 허용해야 함)
        imageUrlToSave = null;
      }

      ref
          .read(profileNotifierProvider.notifier)
          .updateProfileInfo(
            nickname: _nicknameController.text.trim(),
            profileImageUrl: imageUrlToSave,
          );
    }
  }

  void _handleProfileImageTap() {
    // TODO: 이미지 피커 로직 구현
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('프로필 이미지 변경 기능 구현 예정입니다.')));
    // 예시: 이미지 피커로 새 URL을 받았다면
    // String newPickedImageUrl = "https://example.com/picked_image.jpg";
    // _profileImageUrlController.text = newPickedImageUrl;
    // _updateCurrentDisplayImageSource(newPickedImageUrl);
  }

  void _navigateToPasswordChangeScreen() {
    context.pushNamed(AppRouteNames.passwordChange);
  }

  Widget _buildReadOnlyField(String label, String value, {IconData? icon}) {
    // 이전과 동일
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
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
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
    ref.listen<ProfileState>(profileNotifierProvider, (previous, next) {
      if (next is ProfileInfoUpdateSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage),
            backgroundColor: AppColors.primary,
          ),
        );
        // 성공 시 컨트롤러 및 표시 이미지 업데이트
        _nicknameController.text = next.userProfile.nickname;
        _profileImageUrlController.text =
            next.userProfile.profileImageUrl ?? '';
        _updateCurrentDisplayImageSource(next.userProfile.profileImageUrl);
      } else if (next is ProfileInfoUpdateFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('프로필 업데이트 실패: ${next.errorMessage}'),
            backgroundColor: Colors.red,
          ),
        );
        // 실패 시, 이전 상태(next.userProfile)로 컨트롤러 값 복원 (선택적)
        _nicknameController.text = next.userProfile.nickname;
        _profileImageUrlController.text =
            next.userProfile.profileImageUrl ?? '';
        _updateCurrentDisplayImageSource(next.userProfile.profileImageUrl);
      }
    });

    final profileState = ref.watch(profileNotifierProvider);
    final bool isUpdating = profileState is ProfileInfoUpdating;
    final UserProfileEntity displayProfile =
        (profileState is ProfileLoaded)
            ? profileState.userProfile
            : widget.initialProfile;

    ImageProvider displayImageProvider;
    if (_currentDisplayImageSource.startsWith('http')) {
      displayImageProvider = NetworkImage(_currentDisplayImageSource);
    } else {
      displayImageProvider = AssetImage(_currentDisplayImageSource);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('회원님의 정보를 입력해주세요!'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          if (isUpdating)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: _handleProfileImageTap,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: displayImageProvider,
                      onBackgroundImageError: (exception, stackTrace) {
                        // 네트워크 이미지 로드 실패 시 기본 에셋 이미지로 변경
                        print('Network image load error: $exception');
                        if (mounted) {
                          setState(() {
                            _currentDisplayImageSource = _defaultProfileAsset;
                          });
                        }
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _profileImageUrlController,
                decoration: const InputDecoration(
                  labelText: '프로필 이미지 URL',
                  hintText: 'URL을 입력하거나 위 카메라 아이콘을 누르세요',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.link),
                ),
                style: AppTextStyle.regular,
                keyboardType: TextInputType.url,
                onChanged: (value) {
                  _updateCurrentDisplayImageSource(value);
                },
              ),
              const SizedBox(height: 32),
              _buildReadOnlyField("이름", displayProfile.name),
              _buildReadOnlyField("학번", displayProfile.studentNumber),
              _buildReadOnlyField("이메일", displayProfile.email),
              _buildReadOnlyField("총 포인트", "${displayProfile.totalPoint} P"),
              const SizedBox(height: 32),
              TextFormField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  labelText: '나무 이름 (닉네임)',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.eco_outlined),
                  hintText: '새로운 나무 이름을 입력하세요',
                  labelStyle: AppTextStyle.medium,
                ),
                style: AppTextStyle.regular,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '나무 이름을 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.lock_person_outlined, size: 20),
                  label: Text('비밀번호 변경', style: AppTextStyle.medium),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _navigateToPasswordChangeScreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
