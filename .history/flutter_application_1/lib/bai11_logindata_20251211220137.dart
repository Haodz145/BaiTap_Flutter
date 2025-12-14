import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ==========================================
// 1. MODEL: Ánh xạ dữ liệu từ API về App
// ==========================================
class UserProfile {
  final String fullName;
  final String jobTitle;
  final String image;
  final String email;
  final String phone;
  final String address;
  final String gender;
  final String company;
  final String cardType;
  final String cardNumber;

  UserProfile({
    required this.fullName,
    required this.jobTitle,
    required this.image,
    required this.email,
    required this.phone,
    required this.address,
    required this.gender,
    required this.company,
    required this.cardType,
    required this.cardNumber,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      fullName: "${json['firstName']} ${json['lastName']}",
      jobTitle: json['company']['title'] ?? "N/A",
      image: json['image'],
      email: json['email'],
      phone: json['phone'],
      address: "${json['address']['address']}, ${json['address']['city']}",
      gender: json['gender'],
      company: json['company']['name'],
      // Dữ liệu ngân hàng (đôi khi API trả về, đôi khi không, cần check null)
      cardType: json['bank'] != null ? json['bank']['cardType'] : "Visa",
      cardNumber: json['bank'] != null ? json['bank']['cardNumber'] : "****",
    );
  }
}

// ==========================================
// 2. MÀN HÌNH LOGIN (GỌI API)
// ==========================================
class LoginApiScreen extends StatefulWidget {
  const LoginApiScreen({super.key});

  @override
  State<LoginApiScreen> createState() => _LoginApiScreenState();
}

class _LoginApiScreenState extends State<LoginApiScreen> {
  final _userController = TextEditingController(
    text: "emilys",
  ); // Tài khoản mẫu
  final _passController = TextEditingController(
    text: "emilyspass",
  ); // Mật khẩu mẫu
  bool _isLoading = false; // Biến để hiện vòng quay loading

  // Hàm gọi API Đăng nhập
  Future<void> _login() async {
    if (_userController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập tài khoản/mật khẩu")),
      );
      return;
    }

    setState(() => _isLoading = true); // Bật loading

    try {
      // 1. Gửi request lên Server
      final response = await http.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _userController.text,
          'password': _passController.text,
        }),
      );

      // 2. Kiểm tra kết quả
      if (response.statusCode == 200) {
        // Thành công: Parse dữ liệu
        final data = jsonDecode(response.body);
        final user = UserProfile.fromJson(data);

        if (!mounted) return;

        // Chuyển sang màn hình Info
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserInfoScreen(user: user)),
        );
      } else {
        // Thất bại (Sai pass, v.v.)
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sai tài khoản hoặc mật khẩu!")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lỗi kết nối: $e")));
    } finally {
      setState(
        () => _isLoading = false,
      ); // Tắt loading dù thành công hay thất bại
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5),
      appBar: AppBar(
        title: const Text("Bài 11: Login API"),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_sync, size: 80, color: Color(0xFF9C27B0)),
            const SizedBox(height: 20),

            TextField(
              controller: _userController,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : _login, // Nếu đang load thì khóa nút
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C27B0),
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "ĐĂNG NHẬP (API)",
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Tài khoản mẫu: emilys / emilyspass",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. MÀN HÌNH PROFILE (HIỂN THỊ DỮ LIỆU)
// ==========================================
class UserInfoScreen extends StatelessWidget {
  final UserProfile user;

  const UserInfoScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5),
      appBar: AppBar(
        title: const Text("Hồ sơ (Từ API)"),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              width: double.infinity,
              color: const Color(0xFFF3E5F5),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user.image), // Ảnh từ API
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A148C),
                    ),
                  ),
                  Text(
                    user.jobTitle,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Thông tin chi tiết
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildCard("Thông tin liên hệ", [
                    _row(Icons.email, "Email", user.email),
                    _row(Icons.phone, "SĐT", user.phone),
                    _row(Icons.location_on, "Địa chỉ", user.address),
                  ]),
                  const SizedBox(height: 15),
                  _buildCard("Công việc", [
                    _row(Icons.business, "Công ty", user.company),
                    _row(Icons.work, "Vị trí", user.jobTitle),
                  ]),
                  const SizedBox(height: 15),
                  _buildCard("Thông tin khác", [
                    _row(Icons.person, "Giới tính", user.gender),
                    _row(Icons.credit_card, "Loại thẻ", user.cardType),
                    _row(Icons.numbers, "Số thẻ", user.cardNumber),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, List<Widget> children) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8E24AA),
              ),
            ),
            const Divider(color: Colors.purpleAccent),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text("$label: $value", style: const TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }
}
