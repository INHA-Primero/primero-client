// lib/features/profile/ui/screens/password_change_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/core/theme/app_colors.dart';
import 'package:primero/core/theme/app_text_style.dart';
import 'package:primero/features/profile/providers/profile_di.dart';
import 'package:primero/features/profile/providers/profile_state.dart';

class PasswordChangeScreen extends ConsumerStatefulWidget {
  const PasswordChangeScreen({super.key});

  @override
  ConsumerState<PasswordChangeScreen> createState() =>
      _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends ConsumerState<PasswordChangeScreen> {
  final _formKey = GlobalKey<FormState>();
  // [삭제] final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  // [삭제] bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmNewPassword = true;

  // [추가] UI에서 로딩 상태를 관리하기 위한 변수
  bool _isChanging = false;

  @override
  void dispose() {
    // [삭제] _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  // ✨ [수정됨] _submitChangePassword 메서드에서 성공 SnackBar 호출부 삭제
  Future<void> _submitChangePassword() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      setState(() => _isChanging = true);

      final success = await ref
          .read(profileNotifierProvider.notifier)
          .changePassword(newPassword: _newPasswordController.text);

      if (mounted) {
        if (success) {
          // 딜레이 후 화면 닫기
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted && Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          });
        } else {
          final currentState = ref.read(profileNotifierProvider);
          final errorMessage = currentState.maybeWhen(
            error: (msg, _) => msg,
            orElse: () => '알 수 없는 오류가 발생했습니다.',
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('비밀번호 변경 실패: $errorMessage'),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() => _isChanging = false);
      }
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
    // ... (이 위젯은 변경 없음)
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // [삭제] ref.listen은 더 이상 필요 없습니다.

    return Scaffold(
      appBar: AppBar(title: const Text('비밀번호 변경'), elevation: 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // [삭제] API 명세에 따라 현재 비밀번호 필드 제거
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
                    return '비밀번호는 6자 이상이어야 합니다.';
                  }
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
                // [수정] _isChanging으로 로딩 상태 제어
                onPressed: _isChanging ? null : _submitChangePassword,
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
                    _isChanging
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
