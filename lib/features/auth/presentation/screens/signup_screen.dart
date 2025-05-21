// lib/features/auth/presentation/screens/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:primero/app/app_router.dart';
import 'package:primero/core/theme/app_colors.dart';
import 'package:primero/core/theme/app_text_style.dart';
import 'package:primero/features/auth/presentation/providers/auth_di.dart';
import 'package:primero/features/auth/presentation/providers/auth_state.dart';

// 회원가입 단계를 나타내는 enum
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
    final email = _emailController.text.trim();
    if (email.isNotEmpty && email.endsWith('inha.edu')) {
      FocusScope.of(context).unfocus();
      setState(() {
        _emailForVerification = email;
      });
      ref.read(authNotifierProvider.notifier).requestEmailVerification(email);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('올바른 인하대학교 이메일 주소를 입력해주세요.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
    }
  }

  void _resendEmailVerification() {
    if (_emailForVerification.isNotEmpty) {
      FocusScope.of(context).unfocus();
      ref
          .read(authNotifierProvider.notifier)
          .resendEmailVerification(_emailForVerification);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('인증을 요청할 이메일 정보가 없습니다.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
    }
  }

  void _verifyCode() {
    final code = _verificationCodeController.text.trim();
    if (code.isNotEmpty && _emailForVerification.isNotEmpty) {
      FocusScope.of(context).unfocus();
      ref
          .read(authNotifierProvider.notifier)
          .verifyEmailCode(_emailForVerification, code);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('인증번호를 입력해주세요.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
    }
  }

  void _signup() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      ref
          .read(authNotifierProvider.notifier)
          .signup(
            email: _emailForVerification,
            password: _passwordController.text,
            name: _nameController.text.trim(),
            studentNumber: _studentNumberController.text.trim(),
            nickname: _nicknameController.text.trim(),
          );
    }
  }

  // 공통 환영 텍스트 스타일
  final TextStyle commonWelcomeTextStyle = AppTextStyle.bold.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    height: 1.4,
  );

  // 이메일 입력 단계 UI
  Widget _buildEmailStep(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- 환영 문구 (LoginScreen과 동일하게) ---
        Text(
          '안녕하세요!', // 로그인 화면과 동일한 첫 줄
          style: commonWelcomeTextStyle,
        ),
        Text(
          '인하대 이메일로 가입해주세요.', // 로그인 화면과 동일한 두 번째 줄 (내용만 살짝 다름)
          style: commonWelcomeTextStyle,
        ),
        // --- 환영 문구 끝 ---
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
            if (value == null || value.trim().isEmpty) return '이메일을 입력해주세요.';
            if (!value.endsWith('@inha.edu')) return '인하대학교 이메일 주소를 입력해주세요.';
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

  // 인증번호 입력 단계 UI
  Widget _buildVerifyCodeStep(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- 안내 문구 (요청사항 반영) ---
        Text('인증번호를\n입력해주세요', style: commonWelcomeTextStyle),
        // --- 안내 문구 끝 ---
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
            if (value == null || value.trim().isEmpty) return '인증번호를 입력해주세요.';
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
            onPressed: isLoading ? null : _resendEmailVerification,
            child: Text(
              '인증번호 재전송',
              style: AppTextStyle.medium.copyWith(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }

  // 상세 정보 입력 단계 UI
  Widget _buildDetailsStep(bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- 안내 문구 (요청사항 반영) ---
          Text('회원가입', style: commonWelcomeTextStyle),
          // --- 안내 문구 끝 ---
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
              if (value == null || value.isEmpty) return '비밀번호를 입력해주세요.';
              if (value.length < 6) return '비밀번호는 6자 이상이어야 합니다.';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              labelText: '비밀번호 확인',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
              if (value == null || value.isEmpty) return '비밀번호를 다시 한번 입력해주세요.';
              if (value != _passwordController.text) return '비밀번호가 일치하지 않습니다.';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: '이름',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) return '학번을 입력해주세요.';
              if (value.trim().length != 8 ||
                  int.tryParse(value.trim()) == null)
                return '올바른 8자리 학번을 입력해주세요.';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nicknameController,
            decoration: InputDecoration(
              labelText: '닉네임 (나무 이름)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next is AuthEmailVerificationSent) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${next.email}(으)로 인증번호가 발송되었습니다.'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _currentStep = SignupStep.verifyCode;
          _emailForVerification = next.email;
        });
      } else if (next is AuthEmailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${next.email} 이메일 인증 성공! 추가 정보를 입력해주세요.'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _currentStep = SignupStep.enterDetails;
          _emailForVerification = next.email;
        });
      } else if (next is AuthAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('회원가입 성공! ${next.authUser.nickname ?? ''}님 환영합니다.'),
            backgroundColor: AppColors.primary,
          ),
        );
        context.goNamed(AppRouteNames.home);
      } else if (next is AuthFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류: ${next.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    final authState = ref.watch(authNotifierProvider);
    final bool isLoading =
        authState is AuthLoading ||
        authState is AuthEmailVerificationLoading ||
        authState is AuthEmailVerificationConfirmLoading;

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
                      context.goNamed(AppRouteNames.onboarding);
                    } else if (_currentStep == SignupStep.verifyCode) {
                      setState(() => _currentStep = SignupStep.enterEmail);
                    } else if (_currentStep == SignupStep.enterDetails) {
                      setState(() => _currentStep = SignupStep.verifyCode);
                    }
                  },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 20.0,
        ), // 상단 여백 조절
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
    );
  }
}
