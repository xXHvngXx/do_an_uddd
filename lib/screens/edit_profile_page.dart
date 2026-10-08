import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../provider/comment_provider.dart';
import '../provider/post_provider.dart';
import '../provider/profile_provider.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 4 || i == 7) {
        buffer.write(' ');
      }
      buffer.write(digitsOnly[i]);
    }

    final string = buffer.toString();

    if (string.length > 12) {
      return oldValue;
    }

    return TextEditingValue(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Nguyễn Văn X');
  final _usernameController = TextEditingController(text: 'nvx_36');
  final _emailController = TextEditingController(text: 'user@example.com');
  final _phoneController = TextEditingController(text: '0936 363 636');

  String? _avatarUrl;

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final commentProvider =
          Provider.of<CommentProvider>(context, listen: false);
      final newName = _nameController.text.trim();

      if (newName.isNotEmpty) {
        commentProvider.updateGlobalAuthorName(newName);
      }

      context.read<ProfileProvider>().update(
            name: newName,
            username: _usernameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            avatarUrl: _avatarUrl,
          );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lưu thông tin thành công!'),
          backgroundColor: Color(0xFF0F766E),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileProvider>();
    _nameController.text = profile.name;
    _usernameController.text = profile.username;
    _emailController.text = profile.email;
    _phoneController.text = profile.phone;
    _avatarUrl = profile.avatarUrl;
    _nameController.addListener(() {
      setState(() {});
    });

    _usernameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Thay đổi ảnh đại diện',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Material(
                  color: Colors.transparent,
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFCCFBF1),
                      child:
                          Icon(Icons.photo_library, color: Color(0xFF0F766E)),
                    ),
                    title: const Text('Dùng ảnh mẫu 1'),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _avatarUrl =
                            'https://images.unsplash.com/photo-1534528741775-53994a69daeb';
                      });
                    },
                  )),
              Material(
                  color: Colors.transparent,
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFCCFBF1),
                      child: Icon(Icons.camera_alt, color: Color(0xFF0F766E)),
                    ),
                    title: const Text('Dùng ảnh mẫu 2'),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _avatarUrl =
                            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d';
                      });
                    },
                  )),
              if (_avatarUrl != null)
                Material(
                    color: Colors.transparent,
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFFFFE4E6),
                        child:
                            Icon(Icons.delete_outline, color: Colors.redAccent),
                      ),
                      title: const Text(
                        'Xóa ảnh hiện tại',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          _avatarUrl = null;
                        });
                      },
                    )),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    final savedCount = postProvider.posts.where((p) => p.isBookMarked).length;
    final likedCount = postProvider.posts.where((p) => p.isLiked).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Chỉnh sửa thông tin',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Avatar
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _showAvatarPicker,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF0F766E),
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0F766E)
                                      .withValues(alpha: 0.15),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 48,
                              backgroundColor: const Color(0xFFCCFBF1),
                              backgroundImage: _avatarUrl != null
                                  ? NetworkImage(_avatarUrl!)
                                  : null,
                              child: _avatarUrl == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 55,
                                      color: Color(0xFF0F766E),
                                    )
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F766E),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _nameController.text.trim().isEmpty
                          ? 'Tên người dùng'
                          : _nameController.text,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      _usernameController.text.trim().isEmpty
                          ? '@username'
                          : '@${_usernameController.text.replaceAll('@', '')}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.workspace_premium,
                            size: 14,
                            color: Color(0xFFD97706),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Thành Viên',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD97706),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Thống kê
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      '$savedCount',
                      'Đã Lưu',
                      Icons.bookmark_outline,
                    ),
                    Container(
                      height: 24,
                      width: 1,
                      color: const Color(0xFFE2E8F0),
                    ),
                    _buildStatItem(
                      '$likedCount',
                      'Đã Thích',
                      Icons.favorite_outline,
                    ),
                    Container(
                      height: 24,
                      width: 1,
                      color: const Color(0xFFE2E8F0),
                    ),
                    Consumer<CommentProvider>(
                      builder: (context, commentProvider, child) {
                        int countMyComments(List commentsList) {
                          int total = 0;
                          final targetName =
                              _nameController.text.trim().toLowerCase();

                          for (var c in commentsList) {
                            // Đếm bình luận chính
                            if (c.author.trim().toLowerCase() == targetName) {
                              total++;
                            }
                            // Đếm đệ quy các bình luận trả lời bên trong
                            if (c.replies != null && c.replies.isNotEmpty) {
                              total += countMyComments(c.replies);
                            }
                          }
                          return total;
                        }

                        final myCommentCount =
                            countMyComments(commentProvider.comments);
                        return _buildStatItem('$myCommentCount', 'Bình Luận',
                            Icons.chat_bubble_outline);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Inputs
              _buildSectionTitle('Thông tin cá nhân'),
              const SizedBox(height: 12),

              _buildInputField(
                label: 'Họ và tên',
                controller: _nameController,
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập họ và tên';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),
              _buildInputField(
                label: 'Tên tài khoản (Username)',
                controller: _usernameController,
                icon: Icons.alternate_email,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]')),
                  LengthLimitingTextInputFormatter(20),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên tài khoản';
                  }

                  final cleanUsername = value.trim().replaceAll('@', '');

                  if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(cleanUsername)) {
                    return 'Không được chứa khoảng trắng hoặc ký tự đặc biệt';
                  }

                  if (cleanUsername.length < 3) {
                    return 'Tên tài khoản phải từ 3 ký tự trở lên';
                  }

                  if (cleanUsername.length > 20) {
                    return 'Tên tài khoản không được vượt quá 20 ký tự';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),

              _buildInputField(
                label: 'Email',
                controller: _emailController,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  final emailRegExp = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );
                  if (!emailRegExp.hasMatch(value.trim())) {
                    return 'Định dạng email không hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              _buildInputField(
                label: 'Số điện thoại',
                controller: _phoneController,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  PhoneNumberFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }

                  final cleanPhone = value.replaceAll(RegExp(r'\s+'), '');

                  if (!RegExp(r'^\d+$').hasMatch(cleanPhone)) {
                    return 'Số điện thoại chỉ được chứa chữ số';
                  }

                  if (cleanPhone.length < 10) {
                    return 'Số điện thoại quá ngắn (phải đủ 10 số)';
                  }

                  if (cleanPhone.length > 10) {
                    return 'Số điện thoại quá dài (chỉ được đúng 10 số)';
                  }

                  if (!RegExp(r'^(03|05|07|08|09)').hasMatch(cleanPhone)) {
                    return 'Đầu số điện thoại không hợp lệ';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),
              _buildSectionTitle('Cài đặt ứng dụng'),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    Material(
                        color: Colors.transparent,
                        child: ListTile(
                          leading: const Icon(
                            Icons.notifications_none,
                            color: Color(0xFF0F766E),
                          ),
                          title: const Text(
                            'Thông báo ứng dụng',
                            style: TextStyle(fontSize: 14),
                          ),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 14),
                          onTap: () => ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Text(
                                      'Chức năng này đang là giao diện mẫu.'))),
                        )),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    Material(
                        color: Colors.transparent,
                        child: ListTile(
                          leading: const Icon(
                            Icons.security,
                            color: Color(0xFF0F766E),
                          ),
                          title: const Text(
                            'Bảo mật tài khoản',
                            style: TextStyle(fontSize: 14),
                          ),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 14),
                          onTap: () => ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Text(
                                      'Chức năng này đang là giao diện mẫu.'))),
                        )),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F766E),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Lưu Thay Đổi',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 15, color: const Color(0xFF0F766E)),
            const SizedBox(width: 4),
            Text(
              count,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF475569),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        prefixIcon: Icon(icon, color: const Color(0xFF0F766E), size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF0F766E), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}
