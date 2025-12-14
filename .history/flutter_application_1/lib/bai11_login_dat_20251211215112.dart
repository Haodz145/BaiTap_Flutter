import 'package:flutter/material.dart';

// ==========================================
// MÀN HÌNH 1: FORM ĐĂNG NHẬP
// ==========================================
class LoginDataScreen extends StatefulWidget {
  const LoginDataScreen({super.key});

  @override
  State<LoginDataScreen> createState() => _LoginDataScreenState();
}

class _LoginDataScreenState extends State<LoginDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  // Hàm xử lý khi bấm nút Đăng nhập
  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // Chuyển sang màn hình thông tin và GỬI KÈM DỮ LIỆU
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserInfoScreen(
            username: _userController.text,
            password: _passController.text, // (Demo: hiển thị pass để kiểm tra)
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bài 11: Truyền dữ liệu"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_person, size: 80, color: Colors.teal),
              const SizedBox(height: 20),

              // Ô nhập Username
              TextFormField(
                controller: _userController,
                decoration: const InputDecoration(
                  labelText: "Tên đăng nhập",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Vui lòng nhập tên";
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Ô nhập Password
              TextFormField(
                controller: _passController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Mật khẩu",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Vui lòng nhập mật khẩu";
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Nút Đăng nhập
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    "ĐĂNG NHẬP & XEM INFO",
                    style: TextStyle(fontSize: 16),
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

// ==========================================
// MÀN HÌNH 2: HIỂN THỊ THÔNG TIN (NHẬN DỮ LIỆU)
// ==========================================
class UserInfoScreen extends StatelessWidget {
  // Khai báo biến để nhận dữ liệu
  final String username;
  final String password;

  const UserInfoScreen({
    super.key,
    required this.username,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin người dùng"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Card(
          elevation: 5,
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.check, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Đăng nhập thành công!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const Divider(height: 30),

                // Hiển thị dữ liệu nhận được
                Text(
                  "Xin chào, $username",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  "Mật khẩu của bạn là: $password",
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context); // Quay lại trang trước
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Đăng xuất"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
