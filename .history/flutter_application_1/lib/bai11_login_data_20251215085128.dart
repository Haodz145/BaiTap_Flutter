import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

// ============================================================
// PHẦN 1: MODEL (Khuôn dữ liệu User)
// ============================================================
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

// ============================================================
// PHẦN 2: MÀN HÌNH ĐĂNG NHẬP (Login Screen)
// ============================================================
class Bai11LoginScreen extends StatefulWidget {
  const Bai11LoginScreen({super.key});

  @override
  State<Bai11LoginScreen> createState() => _Bai11LoginScreenState();
}

class _Bai11LoginScreenState extends State<Bai11LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Key quản lý Form

  // Controller để lấy dữ liệu nhập vào
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _isLoading = false;

  // Xử lý Đăng Nhập
  Future<void> _handleLogin() async {
    // 1. Validate: Kiểm tra xem đã nhập đúng chưa
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final dio = Dio();
        // 2. Gọi API Login
        final response = await dio.post(
          'https://dummyjson.com/auth/login',
          data: {
            'username': _userController.text.trim(),
            'password': _passController.text.trim(),
          },
        );

        if (response.statusCode == 200) {
          final int userId = response.data['id'];

          if (!mounted) return;

          // 3. Chuyển sang màn hình Profile (nằm ngay bên dưới)
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
          const SnackBar(
            content: Text("Sai tài khoản hoặc mật khẩu!"),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Đăng Nhập Hệ Thống")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            // <--- BẮT ĐẦU FORM
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock_person_rounded,
                  size: 80,
                  color: Colors.indigo,
                ),
                const SizedBox(height: 20),
                const Text(
                  "WELCOME BACK",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),

                // Ô nhập User
                TextFormField(
                  controller: _userController,
                  decoration: const InputDecoration(
                    labelText: "Tài khoản",
                    hintText: "Nhập username (vd: kminchelle)",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Vui lòng nhập tài khoản';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Ô nhập Pass
                TextFormField(
                  controller: _passController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Mật khẩu",
                    hintText: "Nhập mật khẩu (vd: 0lelplR)",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.key),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Vui lòng nhập mật khẩu';
                    if (value.length < 6) return 'Mật khẩu quá ngắn';
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Nút Login
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "ĐĂNG NHẬP",
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                ),

                // Gợi ý
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.grey[100],
                  child: const Text(
                    "TK Test: kminchelle | MK: 0lelplR",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// PHẦN 3: MÀN HÌNH HỒ SƠ (Profile Screen)
// ============================================================
class Bai11ProfileScreen extends StatefulWidget {
  final int userId; // Nhận ID từ màn hình trên truyền xuống

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

  // Lấy dữ liệu chi tiết User theo ID
  Future<void> _fetchUserData() async {
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
        actions: [
          // Nút Đăng xuất
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Quay ngược lại màn hình đăng nhập
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Bai11LoginScreen(),
                ),
              );
            },
          ),
        ],
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
                  // Avatar
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.purple[100],
                    backgroundImage: NetworkImage(_user!.image),
                  ),
                  const SizedBox(height: 10),
                  // Tên
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

                  // Các Card thông tin
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

  // Widget khung bao ngoài
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

  // Widget từng dòng thông tin
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
