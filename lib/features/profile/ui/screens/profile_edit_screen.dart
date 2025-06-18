// lib/features/profile/ui/screens/profile_edit_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:primero/core/theme/app_colors.dart';
import 'package:primero/core/theme/app_text_style.dart';
import 'package:primero/features/profile/models/user_profile_model.dart';
import 'package:primero/features/profile/providers/profile_di.dart';
import 'package:primero/features/profile/providers/profile_state.dart';
import 'password_change_screen.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  final UserProfileModel initialProfile;
  const ProfileEditScreen({super.key, required this.initialProfile});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  late TextEditingController _treeNameController;
  final _formKey = GlobalKey<FormState>();
  File? _pickedImageFile;
  dynamic _displayImageSource;
  // [수정] 기본 이미지 경로를 일관성 있게 관리하기 위해 babyTree2.png로 수정
  static const String _defaultProfileAsset = 'assets/images/babyTree2.png';

  // [수정] 로딩 상태를 UI에서 직접 관리
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _treeNameController = TextEditingController(
      text: widget.initialProfile.treeName,
    );
    _updateDisplayImageSource(newUrl: widget.initialProfile.profileImgPath);
  }

  void _updateDisplayImageSource({File? newFile, String? newUrl}) {
    setState(() {
      if (newFile != null) {
        _displayImageSource = newFile;
      } else if (newUrl != null &&
          newUrl.isNotEmpty &&
          newUrl.startsWith('http')) {
        _displayImageSource = newUrl;
      } else {
        _displayImageSource = _defaultProfileAsset;
      }
    });
  }

  @override
  void dispose() {
    _treeNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedXFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedXFile != null) {
        _pickedImageFile = File(pickedXFile.path);
        _updateDisplayImageSource(newFile: _pickedImageFile);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('갤러리에서 이미지를 가져오는 데 실패했습니다: $e')));
      }
    }
  }

  // ✨ [수정됨] _submitUpdate 메서드에서 성공 SnackBar 호출부 삭제
  Future<void> _submitUpdate() async {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      setState(() => _isUpdating = true);

      final success = await ref
          .read(profileNotifierProvider.notifier)
          .updateProfileData(
            newNickname: _treeNameController.text.trim(),
            newImageFile: _pickedImageFile,
          );

      // 위젯이 아직 화면에 마운트되어 있는지 확인 후 UI 업데이트
      if (mounted) {
        if (success) {
          Navigator.pop(context); // 성공 시 이전 화면으로 이동
        } else {
          // 실패 시 Notifier가 error 상태로 전환했으므로, 그 상태를 읽어 메시지 표시
          final currentState = ref.read(profileNotifierProvider);
          final errorMessage = currentState.maybeWhen(
            error: (msg, _) => msg,
            orElse: () => '알 수 없는 오류가 발생했습니다.',
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('프로필 업데이트 실패: $errorMessage'),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() => _isUpdating = false);
      }
    }
  }

  void _navigateToPasswordChangeScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const PasswordChangeScreen()),
    );
  }

  Widget _buildReadOnlyField(String label, String value, {IconData? icon}) {
    // ... (이 위젯은 변경 없음)
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
    // [삭제] ref.listen은 더 이상 필요 없습니다.

    ImageProvider displayImageProvider;
    if (_displayImageSource is File) {
      displayImageProvider = FileImage(_displayImageSource as File);
    } else if (_displayImageSource is String &&
        (_displayImageSource as String).startsWith('http')) {
      displayImageProvider = NetworkImage(_displayImageSource as String);
    } else {
      displayImageProvider = const AssetImage(_defaultProfileAsset);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('회원님의 정보를 입력해주세요!'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          // [수정] 로딩 상태를 _isUpdating 변수로 제어
          if (_isUpdating)
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
                onTap: _isUpdating ? null : _pickImageFromGallery,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: displayImageProvider,
                      onBackgroundImageError: (exception, stackTrace) {
                        if (mounted &&
                            _displayImageSource is String &&
                            (_displayImageSource as String).startsWith(
                              'http',
                            )) {
                          _updateDisplayImageSource(
                            newFile: null,
                            newUrl: null,
                          );
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
              const SizedBox(height: 32),
              _buildReadOnlyField(
                "이름",
                widget.initialProfile.name,
                icon: Icons.person_outline,
              ),
              _buildReadOnlyField(
                "학번",
                widget.initialProfile.studentNumber.toString(),
                icon: Icons.school_outlined,
              ),
              _buildReadOnlyField(
                "이메일",
                widget.initialProfile.email,
                icon: Icons.email_outlined,
              ),
              _buildReadOnlyField(
                "총 포인트",
                "${widget.initialProfile.totalPoint} P",
                icon: Icons.star_outline,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _treeNameController,
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
