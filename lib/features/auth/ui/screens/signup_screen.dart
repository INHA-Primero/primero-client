// lib/features/auth/ui/screens/signup_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/core/theme/app_colors.dart';
import 'package:primero/core/theme/app_text_style.dart';
import 'package:primero/features/auth/providers/auth_di.dart';
import 'package:primero/features/auth/providers/auth_state.dart';

enum SignupStep { enterEmail, verifyCode, enterDetails }

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _verificationCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _studentNumberController = TextEditingController();
  final _nicknameController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  SignupStep _currentStep = SignupStep.enterEmail;
  String _emailForVerification = '';

  @override
  void dispose() {
    _emailController.dispose();
    _verificationCodeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _studentNumberController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  void _requestEmailVerification() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      FocusScope.of(context).unfocus();
      setState(() {
        _emailForVerification = email;
      });
      ref.read(authNotifierProvider.notifier).sendVerificationCode(email);
    }
  }

  void _verifyCode() {
    if (_verificationCodeController.text.trim().isNotEmpty) {
      FocusScope.of(context).unfocus();
      ref
          .read(authNotifierProvider.notifier)
          .verifyCode(
            email: _emailForVerification,
            code: _verificationCodeController.text.trim(),
          );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('인증번호를 입력해주세요.')));
    }
  }

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      final deviceUuid =
          await ref.read(deviceUuidServiceProvider).getOrCreateDeviceUuid();

      ref
          .read(authNotifierProvider.notifier)
          .signup(
            email: _emailForVerification,
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
            name: _nameController.text.trim(),
            studentNumber: int.parse(_studentNumberController.text.trim()),
            treeName: _nicknameController.text.trim(),
            deviceUuid: deviceUuid,
          );
    }
  }

  final TextStyle commonWelcomeTextStyle = AppTextStyle.bold.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    height: 1.4,
  );

  // UI를 그리는 위젯(_buildEmailStep, _buildVerifyCodeStep, _buildDetailsStep)들은
  // 기존 코드와 동일하며, 변경할 필요가 없습니다.
  Widget _buildEmailStep(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('안녕하세요!', style: commonWelcomeTextStyle),
        Text('인하대 이메일로 가입해주세요.', style: commonWelcomeTextStyle),
        const SizedBox(height: 20),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: '이메일',
            hintText: 'ex)plastic@inha.edu',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '이메일을 입력해주세요.';
            }
            if (!value.endsWith('@inha.edu')) {
              return '인하대학교 이메일 주소를 입력해주세요.';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : _requestEmailVerification,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: AppTextStyle.semiBold.copyWith(fontSize: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
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
                    : const Text('인증하기'),
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyCodeStep(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('인증번호를\n입력해주세요', style: commonWelcomeTextStyle),
        const SizedBox(height: 8),
        Text(
          '$_emailForVerification (으)로 전송된 인증번호를 입력해주세요.',
          style: AppTextStyle.regular.copyWith(
            fontSize: 15,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 30),
        TextFormField(
          controller: _verificationCodeController,
          decoration: InputDecoration(
            labelText: '인증번호',
            hintText: '인증번호 입력',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          keyboardType: TextInputType.number,
          style: AppTextStyle.medium.copyWith(fontSize: 18),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '인증번호를 입력해주세요.';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : _verifyCode,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: AppTextStyle.semiBold.copyWith(fontSize: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
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
                    : const Text('인증번호 확인'),
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.center,
          child: TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('재전송 기능은 현재 지원되지 않습니다.')),
              );
            },
            child: Text(
              '인증번호 재전송',
              style: AppTextStyle.medium.copyWith(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsStep(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('회원가입', style: commonWelcomeTextStyle),
        const SizedBox(height: 8),
        Text(
          '마지막 단계예요! 정보를 입력해주세요.',
          style: AppTextStyle.regular.copyWith(
            fontSize: 15,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 30),
        Text(
          '인증된 이메일: $_emailForVerification',
          style: AppTextStyle.medium.copyWith(
            color: Colors.black54,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: '비밀번호',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed:
                  () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          obscureText: _obscurePassword,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '비밀번호를 입력해주세요.';
            }
            if (value.length < 6) {
              return '비밀번호는 6자 이상이어야 합니다.';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _confirmPasswordController,
          decoration: InputDecoration(
            labelText: '비밀번호 확인',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed:
                  () => setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword,
                  ),
            ),
          ),
          obscureText: _obscureConfirmPassword,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '비밀번호를 다시 한번 입력해주세요.';
            }
            if (value != _passwordController.text) {
              return '비밀번호가 일치하지 않습니다.';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: '이름',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          validator:
              (value) =>
                  (value == null || value.trim().isEmpty)
                      ? '이름을 입력해주세요.'
                      : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _studentNumberController,
          decoration: InputDecoration(
            labelText: '학번',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '학번을 입력해주세요.';
            }
            if (value.trim().length != 8 ||
                int.tryParse(value.trim()) == null) {
              return '올바른 8자리 학번을 입력해주세요.';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _nicknameController,
          decoration: InputDecoration(
            labelText: '닉네임 (나무 이름)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          validator:
              (value) =>
                  (value == null || value.trim().isEmpty)
                      ? '닉네임을 입력해주세요.'
                      : null,
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : _signup,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: AppTextStyle.semiBold.copyWith(fontSize: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
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
                    : const Text('회원가입 완료'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✨ [수정됨] ref.listen에서 모든 성공 관련 SnackBar 호출부 삭제
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        authenticated: () {
          if (mounted) {
            // 모든 상위 화면을 닫고 첫 화면으로 이동
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
        codeSentSuccess: () {
          setState(() {
            _currentStep = SignupStep.verifyCode;
            _formKey.currentState?.reset();
          });
        },
        verificationSuccess: () {
          setState(() {
            _currentStep = SignupStep.enterDetails;
            _formKey.currentState?.reset();
          });
        },
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('오류: $message'),
              backgroundColor: Colors.red,
            ),
          );
        },
        orElse: () {},
      );
    });

    final authState = ref.watch(authNotifierProvider);
    final bool isLoading = authState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    String appBarTitle;
    Widget currentStepWidget;

    switch (_currentStep) {
      case SignupStep.enterEmail:
        appBarTitle = " ";
        currentStepWidget = _buildEmailStep(isLoading);
        break;
      case SignupStep.verifyCode:
        appBarTitle = "인증번호 입력";
        currentStepWidget = _buildVerifyCodeStep(isLoading);
        break;
      case SignupStep.enterDetails:
        appBarTitle = "회원 정보 입력";
        currentStepWidget = _buildDetailsStep(isLoading);
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed:
              isLoading
                  ? null
                  : () {
                    if (_currentStep == SignupStep.enterEmail) {
                      Navigator.of(context).pop();
                    } else if (_currentStep == SignupStep.verifyCode) {
                      setState(() => _currentStep = SignupStep.enterEmail);
                    } else if (_currentStep == SignupStep.enterDetails) {
                      // [수정] 인증 성공 후 뒤로가기 시 이메일 입력으로 돌아가도록 수정
                      setState(() => _currentStep = SignupStep.enterEmail);
                    }
                  },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Container(
              key: ValueKey<SignupStep>(_currentStep),
              child: currentStepWidget,
            ),
          ),
        ),
      ),
    );
  }
}
