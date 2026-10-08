import 'package:flutter/foundation.dart';

/// Hồ sơ mẫu trong bộ nhớ. Đây không phải xác thực Firebase.
class ProfileProvider extends ChangeNotifier {
  String name = 'Nguyễn Văn X';
  String username = 'nvx_36';
  String email = 'user@example.com';
  String phone = '0936 363 636';
  String? avatarUrl;

  void setDemoEmail(String value) {
    email = value;
    notifyListeners();
  }

  void update(
      {required String name,
      required String username,
      required String email,
      required String phone,
      required String? avatarUrl}) {
    this.name = name;
    this.username = username;
    this.email = email;
    this.phone = phone;
    this.avatarUrl = avatarUrl;
    notifyListeners();
  }
}
