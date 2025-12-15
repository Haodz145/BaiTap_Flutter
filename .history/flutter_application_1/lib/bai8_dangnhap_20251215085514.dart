import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

// ==========================================
// 1. MODEL & MÀN HÌNH PROFILE (Dùng để hứng kết quả)
// ==========================================
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hồ sơ User"),
        backgroundColor: const Color(0xFF9C27B0),
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

// ==========================================
// 2. MÀN HÌNH LOGIN (CODE GIAO DIỆN CỦA BẠN + LOGIC API)
// ==========================================
class LoginExercisePage extends StatefulWidget {
  const LoginExercisePage({super.key});

  @override
  State<LoginExercisePage> createState() => _LoginExercisePageState();
}

class _LoginExercisePageState extends State<LoginExercisePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  // Thêm biến Loading để xử lý nút bấm
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Hàm tạo Style (Giữ nguyên code của bạn)
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

  // --- HÀM XỬ LÝ API ---
  Future<void> _handleLogin() async {
    // 1. Kiểm tra Form hợp lệ
    if (_formKey.currentState!.validate()) {
      // Bật trạng thái loading
      setState(() => _isLoading = true);

      try {
        // 2. Gọi API
        final dio = Dio();
        final response = await dio.post(
          'https://dummyjson.com/auth/login',
          data: {
            'username': _emailController.text.trim(), // API cần username
            'password': _passwordController.text.trim(),
          },
        );

        if (response.statusCode == 200) {
          // 3. Thành công -> Chuyển trang
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
        // 4. Lỗi -> Hiện thông báo đơn giản
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Đăng nhập thất bại! Kiểm tra lại thông tin."),
          ),
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
                // keyboardType: TextInputType.emailAddress, // Tạm tắt để nhập được username thường
                decoration: _inputDecoration(
                  hintText:
                      "Tài khoản (Username)", // Đổi label tí cho đúng logic API
                  prefixIcon: Icons.email_outlined,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tài khoản';
                  }
                  // LƯU Ý: Đã tắt đoạn check Regex Email ở đây để nhập được 'kminchelle'
                  // if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  //   return 'Email không hợp lệ';
                  // }
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
                child: ElevatedButton(
                  // Nếu đang loading thì disable nút
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C27B0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          // Vòng xoay nhỏ màu trắng
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          // Icon + Chữ
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.login, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              "Đăng nhập",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 20),
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
