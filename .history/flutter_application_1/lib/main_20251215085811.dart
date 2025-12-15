import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

// --- GIỮ NGUYÊN PHẦN MODEL VÀ MÀN HÌNH PROFILE ĐỂ APP CHẠY ĐƯỢC ---
class UserProfile {
  final String firstName, lastName, image, title, email, phone, address;
  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.title,
    required this.email,
    required this.phone,
    required this.address,
  });
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['firstName'],
      lastName: json['lastName'],
      image: json['image'],
      title: json['company']['title'],
      email: json['email'],
      phone: json['phone'],
      address: "${json['address']['address']}, ${json['address']['city']}",
    );
  }
}

class Bai11ProfileScreen extends StatelessWidget {
  final int userId;
  const Bai11ProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    // Dùng lại AppBar màu tím để đồng bộ giao diện
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hồ sơ User"),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: Dio().get('https://dummyjson.com/users/$userId'),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(
              child: CircularProgressIndicator(color: Colors.purple),
            );
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
              ],
            ),
          );
        },
      ),
    );
  }
}

// ==================================================================
// BẮT ĐẦU CODE GIAO DIỆN GỐC CỦA BẠN
// ==================================================================
class LoginExercisePage extends StatefulWidget {
  const LoginExercisePage({super.key});

  @override
  State<LoginExercisePage> createState() => _LoginExercisePageState();
}

class _LoginExercisePageState extends State<LoginExercisePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  // [THÊM MỚI] Biến trạng thái loading
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Hàm tạo Style (Code gốc của bạn)
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

  // [THÊM MỚI] Hàm xử lý API
  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true); // Bật loading

      try {
        final dio = Dio();
        final response = await dio.post(
          'https://dummyjson.com/auth/login',
          data: {
            'username': _emailController.text.trim(),
            'password': _passwordController.text.trim(),
          },
        );

        if (response.statusCode == 200) {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Bai11ProfileScreen(userId: response.data['id']),
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Đăng nhập thất bại!")));
      } finally {
        if (mounted) setState(() => _isLoading = false); // Tắt loading
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
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Mũi tên back trắng
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              // --- Input Email ---
              TextFormField(
                controller: _emailController,
                // keyboardType: TextInputType.emailAddress, // Tạm tắt để nhập username test
                decoration: _inputDecoration(
                  hintText:
                      "Tài khoản (kminchelle)", // Sửa hint text xíu cho dễ biết
                  prefixIcon: Icons.email_outlined,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  // LƯU Ý QUAN TRỌNG: Mình tạm comment đoạn check Email này lại
                  // vì API dummyjson yêu cầu nhập username (ví dụ: kminchelle) chứ không phải email.
                  // Nếu để đoạn này lại thì bạn sẽ không bao giờ đăng nhập được.
                  /*
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
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
                  hintText: "Mật khẩu (0lelplR)",
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

              // --- Nút Đăng nhập (GIỮ NGUYÊN CẤU TRÚC CŨ) ---
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton.icon(
                  // SỬA 1: Nếu đang loading thì disable nút, ngược lại gọi hàm API
                  onPressed: _isLoading ? null : _handleLogin,

                  // SỬA 2: Nếu loading thì hiện vòng xoay, ngược lại hiện icon gốc
                  icon: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.login, color: Colors.white),

                  // GIỮ NGUYÊN label
                  label: const Text(
                    "Đăng nhập",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C27B0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
}
