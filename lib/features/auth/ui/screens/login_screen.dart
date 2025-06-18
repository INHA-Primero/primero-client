// lib/features/auth/ui/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/core/theme/app_colors.dart';
import 'package:primero/core/theme/app_text_style.dart';
import 'package:primero/features/auth/providers/auth_di.dart';
import 'package:primero/features/auth/providers/auth_state.dart';
import 'signup_screen.dart'; // 회원가입 화면 import

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      ref
          .read(authNotifierProvider.notifier)
          .login(_emailController.text.trim(), _passwordController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✨ [수정됨] ref.listen에서 authenticated 상태의 SnackBar 호출부 삭제
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        authenticated: () {
          // 로그인/회원가입 과정에서 쌓인 모든 화면을 닫고 첫 화면(AppRouter)으로 돌아갑니다.
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('로그인 실패: $message'),
              backgroundColor: Colors.red,
            ),
          );
        },
        orElse: () {},
      );
    });

    final authState = ref.watch(authNotifierProvider);
    // [오류 수정] 로딩 상태 확인 방법을 새로운 AuthState에 맞게 수정
    final isLoading = authState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    final TextStyle welcomeTextStyle = AppTextStyle.bold.copyWith(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      height: 1.4,
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            // [네비게이션 수정] go_router 대신 Navigator.pop으로 뒤로 가기
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              Text('안녕하세요!', style: welcomeTextStyle),
              Text('인하대 이메일로 로그인해주세요.', style: welcomeTextStyle),
              const SizedBox(height: 30),
              // UI 코드 변경 없음
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: '이메일',
                  hintText: 'ex)plastic@inha.edu',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
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
                  if (!value.contains('@') || !value.endsWith('inha.edu')) {
                    return '올바른 인하대학교 이메일 주소를 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  hintText: '비밀번호 입력',
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
                        () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                  ),
                ),
                obscureText: _obscurePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: AppTextStyle.semiBold.copyWith(fontSize: 18),
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
                          : const Text('로그인'),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // [네비게이션 수정]
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: Text(
                      '회원가입',
                      style: AppTextStyle.regular.copyWith(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    '  |  ',
                    style: AppTextStyle.regular.copyWith(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('비밀번호 찾기 기능 구현 예정입니다.')),
                      );
                    },
                    child: Text(
                      '비밀번호 찾기',
                      style: AppTextStyle.regular.copyWith(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
