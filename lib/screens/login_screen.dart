import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'package:provider/provider.dart';
import '../provider/profile_provider.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _loginDemo() {
    if (!_email.text.trim().contains('@') || _password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Nhập email và mật khẩu để thử giao diện.')));
      return;
    }
    context.read<ProfileProvider>().setDemoEmail(_email.text.trim());
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28),

              // Logo / tên ứng dụng
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Việt Đi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: lightTeal,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.explore_outlined,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 70),

              // Tiêu đề
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Chào mừng trở lại',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Bản giao diện thử nghiệm · chưa xác thực tài khoản',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Email
              const Text(
                'Email',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: inputDecoration(
                  hint: 'Nhập email của bạn',
                  icon: Icons.email_outlined,
                ),
              ),

              const SizedBox(height: 20),

              // Mật khẩu
              const Text(
                'Mật khẩu',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: _password,
                obscureText: true,
                decoration: inputDecoration(
                  hint: 'Nhập mật khẩu',
                  icon: Icons.lock_outline,
                  suffixIcon: Icons.visibility_off_outlined,
                ),
              ),

              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Chưa kết nối chức năng khôi phục mật khẩu.'))),
                  child: const Text(
                    'Quên mật khẩu?',
                    style: TextStyle(
                      fontSize: 14,
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Đăng nhập
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _loginDemo,
                  child: const Text(
                    'Đăng nhập',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Đăng ký
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    'Chưa có tài khoản? ',
                    style: TextStyle(
                      fontSize: 14,
                      color: textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Đăng ký',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Style dùng cho các ô nhập
InputDecoration inputDecoration({
  required String hint,
  required IconData icon,
  IconData? suffixIcon,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      fontSize: 14,
      color: textSecondary,
    ),
    prefixIcon: Icon(
      icon,
      color: primaryColor,
    ),
    suffixIcon: suffixIcon != null
        ? Icon(
            suffixIcon,
            color: textSecondary,
          )
        : null,
    filled: true,
    fillColor: cardColor,
    contentPadding: const EdgeInsets.symmetric(
      vertical: 18,
      horizontal: 16,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Color(0xFFE2E8F0),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: primaryColor,
        width: 1.5,
      ),
    ),
  );
}
