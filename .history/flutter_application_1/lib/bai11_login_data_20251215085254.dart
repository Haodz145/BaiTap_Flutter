import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

// ==========================================
// 1. MODEL (Giữ nguyên để hứng dữ liệu)
// ==========================================
class UserProfile {
  final String firstName;
  final String lastName;
  final String image;
  final String title;
  final String email;
  final String phone;
  final String address;

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

// ==========================================
// 2. MÀN HÌNH ĐĂNG NHẬP (CỰC KỲ ĐƠN GIẢN)
// ==========================================
class Bai11SimpleLogin extends StatefulWidget {
  const Bai11SimpleLogin({super.key});

  @override
  State<Bai11SimpleLogin> createState() => _Bai11SimpleLoginState();
}

class _Bai11SimpleLoginState extends State<Bai11SimpleLogin> {
  // Chỉ cần 2 cái điều khiển text
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _isLoading = false; // Để hiện vòng xoay khi đang bấm nút

  Future<void> _login() async {
    // 1. Kiểm tra rỗng thủ công cho nhanh
    if (_userController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Chưa nhập đủ thông tin!")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dio = Dio();
      // 2. Gọi API
      final response = await dio.post(
        'https://dummyjson.com/auth/login',
        data: {
          'username': _userController.text.trim(),
          'password': _passController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        // Lấy ID và chuyển trang
        final int userId = response.data['id'];
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Bai11ProfileScreen(userId: userId),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Sai tài khoản/mật khẩu")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng Nhập")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ô nhập User đơn giản
            TextField(
              controller: _userController,
              decoration: const InputDecoration(
                labelText: "Tài khoản",
                border: OutlineInputBorder(), // Viền cơ bản
              ),
            ),
            const SizedBox(height: 15),

            // Ô nhập Pass đơn giản
            TextField(
              controller: _passController,
              obscureText: true, // Ẩn mật khẩu
              decoration: const InputDecoration(
                labelText: "Mật khẩu",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),

            // Nút bấm
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Đăng Nhập"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. MÀN HÌNH PROFILE (HIỂN THỊ KẾT QUẢ)
// ==========================================
class Bai11ProfileScreen extends StatefulWidget {
  final int userId;
  const Bai11ProfileScreen({super.key, required this.userId});

  @override
  State<Bai11ProfileScreen> createState() => _Bai11ProfileScreenState();
}

class _Bai11ProfileScreenState extends State<Bai11ProfileScreen> {
  UserProfile? _user;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    try {
      var res = await Dio().get('https://dummyjson.com/users/${widget.userId}');
      setState(() {
        _user = UserProfile.fromJson(res.data);
      });
    } catch (e) {
      print("Lỗi: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thông tin User")),
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(_user!.image),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "${_user!.firstName} ${_user!.lastName}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _user!.title,
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Text("Email: ${_user!.email}"),
                  Text("Phone: ${_user!.phone}"),
                  Text(
                    "Địa chỉ: ${_user!.address}",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
    );
  }
}
