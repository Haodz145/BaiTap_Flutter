import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

// ===================================================
// 1. MODEL: Khuôn đúc dữ liệu User (Giữ nguyên)
// ===================================================
class UserProfile {
  final String firstName;
  final String lastName;
  final String image;
  final String title;
  final String birthDate;
  final String gender;
  final String bloodGroup;
  final double height;
  final String email;
  final String phone;
  final String address;
  final String companyName;
  final String department;
  final String cardType;
  final String cardNumber;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.title,
    required this.birthDate,
    required this.gender,
    required this.bloodGroup,
    required this.height,
    required this.email,
    required this.phone,
    required this.address,
    required this.companyName,
    required this.department,
    required this.cardType,
    required this.cardNumber,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['firstName'],
      lastName: json['lastName'],
      image: json['image'],
      title: json['company']['title'],
      birthDate: json['birthDate'],
      gender: json['gender'],
      bloodGroup: json['bloodGroup'],
      height: (json['height'] as num).toDouble(),
      email: json['email'],
      phone: json['phone'],
      address: "${json['address']['address']}, ${json['address']['city']}",
      companyName: json['company']['name'],
      department: json['company']['department'],
      cardType: json['bank']['cardType'],
      cardNumber: json['bank']['cardNumber'],
    );
  }
}

// ===================================================
// 2. MÀN HÌNH ĐĂNG NHẬP (Login Screen)
// ===================================================
class Bai11LoginScreen extends StatefulWidget {
  const Bai11LoginScreen({super.key});

  @override
  State<Bai11LoginScreen> createState() => _Bai11LoginScreenState();
}

class _Bai11LoginScreenState extends State<Bai11LoginScreen> {
  // Tài khoản mẫu của DummyJSON
  final TextEditingController _userController = TextEditingController(
    text: "emilys",
  );
  final TextEditingController _passController = TextEditingController(
    text: "emilyspass",
  );
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (_userController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dio = Dio();
      // Gọi API Login (Phương thức POST)
      final response = await dio.post(
        'https://dummyjson.com/auth/login',
        data: {
          'username': _userController.text,
          'password': _passController.text,
        },
      );

      if (response.statusCode == 200) {
        // Đăng nhập thành công!
        // Lấy ID và Token từ server trả về
        final int userId = response.data['id'];
        final String token =
            response.data['accessToken']; // Có thể dùng để lưu trữ sau này

        if (!mounted) return;

        // Chuyển sang màn hình Profile và truyền ID người dùng sang
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Bai11ProfileScreen(userId: userId),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đăng nhập thất bại! Kiểm tra lại pass. ($e)")),
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
                  const Icon(Icons.lock_person, size: 80, color: Colors.purple),
                  const SizedBox(height: 20),
                  const Text(
                    "ĐĂNG NHẬP",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _userController,
                    decoration: const InputDecoration(
                      labelText: "Tài khoản",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passController,
                    obscureText: true, // Ẩn mật khẩu
                    decoration: const InputDecoration(
                      labelText: "Mật khẩu",
                      prefixIcon: Icon(Icons.key),
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
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Đăng nhập ngay",
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Gợi ý: user: emilys | pass: emilyspass",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
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

// ===================================================
// 3. MÀN HÌNH HỒ SƠ (Profile Screen)
// ===================================================
class Bai11ProfileScreen extends StatefulWidget {
  final int userId; // Nhận ID từ màn hình đăng nhập

  const Bai11ProfileScreen({super.key, required this.userId});

  @override
  State<Bai11ProfileScreen> createState() => _Bai11ProfileScreenState();
}

class _Bai11ProfileScreenState extends State<Bai11ProfileScreen> {
  UserProfile? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    // Gọi API lấy thông tin người dùng theo ID đã đăng nhập
    final url = 'https://dummyjson.com/users/${widget.userId}';

    try {
      final dio = Dio();
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _user = UserProfile.fromJson(response.data);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        title: const Text("Hồ sơ cá nhân"),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.purple))
          : _user == null
          ? const Center(child: Text("Lỗi tải dữ liệu"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.purple[100],
                    backgroundImage: NetworkImage(_user!.image),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${_user!.firstName} ${_user!.lastName}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  Text(
                    _user!.title,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  _buildInfoCard("Thông tin cá nhân", [
                    _buildRowInfo(Icons.cake, "Ngày sinh", _user!.birthDate),
                    _buildRowInfo(Icons.person, "Giới tính", _user!.gender),
                    _buildRowInfo(
                      Icons.bloodtype,
                      "Nhóm máu",
                      _user!.bloodGroup,
                    ),
                    _buildRowInfo(
                      Icons.height,
                      "Chiều cao",
                      "${_user!.height} cm",
                    ),
                  ]),
                  const SizedBox(height: 20),
                  _buildInfoCard("Liên hệ", [
                    _buildRowInfo(Icons.email, "Email", _user!.email),
                    _buildRowInfo(Icons.phone, "SĐT", _user!.phone),
                    _buildRowInfo(Icons.location_on, "Địa chỉ", _user!.address),
                  ]),
                  const SizedBox(height: 20),
                  _buildInfoCard("Tài chính", [
                    _buildRowInfo(
                      Icons.credit_card,
                      "Loại thẻ",
                      _user!.cardType,
                    ),
                    _buildRowInfo(
                      Icons.numbers,
                      "Số thẻ",
                      "**** **** **** ${_user!.cardNumber.substring(_user!.cardNumber.length - 4)}",
                    ),
                  ]),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                color: Colors.purple,
              ),
            ),
            const Divider(color: Colors.purple, thickness: 0.5),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildRowInfo(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
