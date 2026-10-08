import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  @override
  void dispose() {
    for (final c in [_name, _email, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  void _registerDemo() {
    if (_name.text.trim().isEmpty ||
        !_email.text.trim().contains('@') ||
        _password.text.length < 6 ||
        _confirm.text != _password.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Nhập đủ họ tên, email, mật khẩu ít nhất 6 ký tự và xác nhận trùng khớp.')));
      return;
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Đã kiểm tra biểu mẫu. Chưa tạo tài khoản Firebase; bạn có thể thử đăng nhập mẫu.')));
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
              const SizedBox(height: 18),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 18),
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Tạo tài khoản',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Bắt đầu hành trình khám phá của bạn',
                      style: TextStyle(
                        fontSize: 14,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              const Text(
                'Họ và tên',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _name,
                decoration: inputDecoration(
                  hint: 'Nhập họ và tên',
                  icon: Icons.person_outline,
                ),
              ),
              const SizedBox(height: 18),
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
                decoration: inputDecoration(
                  hint: 'Nhập email',
                  icon: Icons.email_outlined,
                ),
              ),
              const SizedBox(height: 18),
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
              const SizedBox(height: 18),
              const Text(
                'Xác nhận mật khẩu',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _confirm,
                obscureText: true,
                decoration: inputDecoration(
                  hint: 'Nhập lại mật khẩu',
                  icon: Icons.lock_reset_outlined,
                  suffixIcon: Icons.visibility_off_outlined,
                ),
              ),
              const SizedBox(height: 30),
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
                  onPressed: _registerDemo,
                  child: const Text(
                    'Đăng ký',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    'Đã có tài khoản? ',
                    style: TextStyle(
                      fontSize: 14,
                      color: textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Đăng nhập',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

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
