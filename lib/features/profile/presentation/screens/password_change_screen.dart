// lib/features/profile/presentation/screens/password_change_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/core/theme/app_colors.dart';
import 'package:primero/core/theme/app_text_style.dart';
import 'package:primero/features/profile/presentation/providers/profile_di.dart';
import 'package:primero/features/profile/presentation/providers/profile_state.dart';
// import 'package:go_router/go_router.dart'; // 현재는 Navigator.pop 사용

class PasswordChangeScreen extends ConsumerStatefulWidget {
  const PasswordChangeScreen({super.key});

  @override
  ConsumerState<PasswordChangeScreen> createState() =>
      _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends ConsumerState<PasswordChangeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmNewPassword = true;

  @override
  void initState() {
    super.initState();
    // 비밀번호 변경 화면 진입 시, 이전 상태를 초기화하여 이전 작업의 성공/실패 메시지가 보이지 않도록 함
    // (선택적: Notifier에서 이 화면 진입 시 초기화 상태를 emit하도록 할 수도 있음)
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(profileNotifierProvider.notifier).resetPasswordChangeState(); // Notifier에 이런 메서드 추가 필요
    // });
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  void _submitChangePassword() {
    // 키보드 숨기기
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      // 새 비밀번호와 확인 비밀번호 일치 여부는 validator에서 이미 처리
      ref
          .read(profileNotifierProvider.notifier)
          .changePassword(
            currentPassword: _currentPasswordController.text,
            newPassword: _newPasswordController.text,
          );
    }
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required bool obscureText,
    required VoidCallback toggleObscureText,
    String? Function(String?)? validator,
    String? hintText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          prefixIcon: const Icon(Icons.lock_outline, size: 20),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 20,
            ),
            onPressed: toggleObscureText,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14.0,
            horizontal: 16.0,
          ),
        ),
        style: AppTextStyle.regular,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction, // 사용자 입력 시마다 검증
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ProfileState>(profileNotifierProvider, (previous, next) {
      if (next is PasswordChangeSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage),
            backgroundColor: AppColors.primary,
            duration: const Duration(seconds: 2),
          ),
        );
        // 성공 시 1초 후 이전 화면(ProfileEditScreen)으로 자동 이동
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted && Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        });
      } else if (next is PasswordChangeFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('비밀번호 변경 실패: ${next.errorMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    final profileState = ref.watch(profileNotifierProvider);
    final bool isLoading = profileState is PasswordChangeLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('비밀번호 변경'), elevation: 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildPasswordField(
                controller: _currentPasswordController,
                labelText: '현재 비밀번호',
                obscureText: _obscureCurrentPassword,
                toggleObscureText:
                    () => setState(
                      () => _obscureCurrentPassword = !_obscureCurrentPassword,
                    ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '현재 비밀번호를 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildPasswordField(
                controller: _newPasswordController,
                labelText: '새 비밀번호',
                hintText: '6자 이상 입력해주세요',
                obscureText: _obscureNewPassword,
                toggleObscureText:
                    () => setState(
                      () => _obscureNewPassword = !_obscureNewPassword,
                    ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '새 비밀번호를 입력해주세요.';
                  }
                  if (value.length < 6) {
                    // 예시: 최소 길이
                    return '비밀번호는 6자 이상이어야 합니다.';
                  }
                  // TODO: 비밀번호 복잡도 규칙 추가 가능 (예: 영문, 숫자, 특수문자 조합)
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildPasswordField(
                controller: _confirmNewPasswordController,
                labelText: '새 비밀번호 확인',
                obscureText: _obscureConfirmNewPassword,
                toggleObscureText:
                    () => setState(
                      () =>
                          _obscureConfirmNewPassword =
                              !_obscureConfirmNewPassword,
                    ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '새 비밀번호를 다시 한번 입력해주세요.';
                  }
                  if (value != _newPasswordController.text) {
                    return '새 비밀번호가 일치하지 않습니다.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: isLoading ? null : _submitChangePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: AppTextStyle.semiBold.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child:
                    isLoading
                        ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                        : const Text('비밀번호 변경'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
