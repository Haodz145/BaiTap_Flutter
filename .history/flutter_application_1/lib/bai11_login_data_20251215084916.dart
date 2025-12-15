// ... Giữ nguyên phần class UserProfile ở trên cùng ...

// ===================================================
// 2. MÀN HÌNH ĐĂNG NHẬP (Đã xóa dữ liệu điền sẵn)
// ===================================================
class Bai11LoginScreen extends StatefulWidget {
  const Bai11LoginScreen({super.key});

  @override
  State<Bai11LoginScreen> createState() => _Bai11LoginScreenState();
}

class _Bai11LoginScreenState extends State<Bai11LoginScreen> {
  // SỬA Ở ĐÂY: Bỏ tham số text bên trong ngoặc
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _isLoading = false;

  Future<void> _handleLogin() async {
    // 1. Kiểm tra rỗng
    if (_userController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vui lòng nhập tài khoản và mật khẩu!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dio = Dio();

      // 2. Gọi API Login
      final response = await dio.post(
        'https://dummyjson.com/auth/login',
        data: {
          'username': _userController.text
              .trim(), // trim() để cắt khoảng trắng thừa
          'password': _passController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        // Lấy ID user trả về
        final int userId = response.data['id'];

        if (!mounted) return;

        // Chuyển màn hình
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Bai11ProfileScreen(userId: userId),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      // Thông báo lỗi đẹp hơn
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Sai tài khoản hoặc mật khẩu!"),
          backgroundColor: Colors.red[400],
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.account_circle,
                    size: 80,
                    color: Colors.purple,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "WELCOME BACK",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Đăng nhập để xem hồ sơ",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 30),

                  // Ô nhập User
                  TextField(
                    controller: _userController,
                    decoration: const InputDecoration(
                      labelText: "Tài khoản (Username)",
                      hintText: "Nhập username...",
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Ô nhập Pass
                  TextField(
                    controller: _passController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Mật khẩu",
                      hintText: "Nhập mật khẩu...",
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "ĐĂNG NHẬP",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  // Phần gợi ý tài khoản (Để bạn test cho dễ)
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: const [
                        Text(
                          "Tài khoản mẫu để test (DummyJSON):",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "User: emilys  |  Pass: emilyspass",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "User: michaelw  |  Pass: michaelwpass",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "User: sophIAB  |  Pass: sophIABpass",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ... Giữ nguyên class Bai11ProfileScreen ở bên dưới ...
