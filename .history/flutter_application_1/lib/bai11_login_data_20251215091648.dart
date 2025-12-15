import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // Cần thêm package này vào pubspec.yaml

// ==========================================
// 1. MODEL & MÀN HÌNH PROFILE (Trang đích sau khi đăng nhập)
// ==========================================

class UserProfile {
  final String firstName, lastName, image, title, email;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.title,
    required this.email,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['firstName'],
      lastName: json['lastName'],
      image: json['image'],
      title: json['company']['title'],
      email: json['email'],
    );
  }
}

class Bai11ProfileScreen extends StatelessWidget {
  final int userId;
  const Bai11ProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin User"),
        backgroundColor: const Color(0xFF9C27B0),
      ),
      body: FutureBuilder(
        // Gọi API lấy chi tiết user theo ID
        future: Dio().get('https://dummyjson.com/users/$userId'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.purple),
            );
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Lỗi tải dữ liệu"));
          }

          var user = UserProfile.fromJson(snapshot.data!.data);

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(user.image),
                ),
                const SizedBox(height: 20),
                Text(
                  "${user.firstName} ${user.lastName}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(user.title, style: const TextStyle(color: Colors.grey)),
                Text(
                  user.email,
                  style: const TextStyle(color: Colors.blueGrey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class LoginExercisePage extends StatefulWidget {
  const LoginExercisePage({super.key});

  @override
  State<LoginExercisePage> createState() => _LoginExercisePageState();
}

class _LoginExercisePageState extends State<LoginExercisePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  // Thêm biến loading để xoay vòng tròn khi đang gọi API
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Hàm tạo Style cho ô nhập liệu (Giữ nguyên code của bạn)
  InputDecoration _inputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
      prefixIcon: Icon(prefixIcon, color: Colors.black54),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.black54),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.black54),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Color(0xFF9C27B0), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  // --- Hàm Xử lý API ---
  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true); // Bật loading

      try {
        final dio = Dio();
        final response = await dio.post(
          'https://dummyjson.com/auth/login',
          data: {
            'username': _emailController.text.trim(), // API cần username
            'password': _passwordController.text.trim(),
          },
        );

        if (response.statusCode == 200) {
          // Đăng nhập thành công -> Chuyển trang
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Bai11ProfileScreen(userId: response.data['id']),
            ),
          );
        }
      } catch (e) {
        // Lỗi API -> Hiện thông báo đơn giản
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng nhập thất bại (Sai thông tin)')),
        );
      } finally {
        // Tắt loading dù thành công hay thất bại
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5), // Màu nền tím nhạt
      appBar: AppBar(
        title: const Text(
          "Bài 8: Form Đăng nhập",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF9C27B0), // Màu tím đậm
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              // --- Input Email (Username) ---
              TextFormField(
                controller: _emailController,
                // keyboardType: TextInputType.emailAddress, // Tắt cái này để nhập username dễ hơn
                decoration: _inputDecoration(
                  hintText: "Tài khoản (Username)", // Đổi hint cho đúng API
                  prefixIcon: Icons.email_outlined,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tài khoản';
                  }
                  // Tạm bỏ đoạn check Email Regex để nhập được 'kminchelle'
                  /* if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Email không hợp lệ';
                  }
                  */
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // --- Input Mật khẩu ---
              TextFormField(
                controller: _passwordController,
                obscureText: _isObscure,
                decoration: _inputDecoration(
                  hintText: "Mật khẩu",
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey[700],
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 40),

              // --- Nút Đăng nhập ---
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : _handleLogin, // Nếu đang load thì khóa nút
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.login, color: Colors.white),
                  label: Text(
                    _isLoading ? "Đang xử lý..." : "Đăng nhập",
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C27B0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              // Hint cho user biết tài khoản test
              const Text(
                "TK: kminchelle | MK: 0lelplR",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
