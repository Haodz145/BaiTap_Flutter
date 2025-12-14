import 'package:flutter/material.dart';

// ==========================================
// 1. MODEL: Ánh xạ dữ liệu JSON
// ==========================================
class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String image;
  final String birthDate;
  final String gender;
  final String bloodGroup;
  final double height;
  final String addressStr;
  final String companyName;
  final String jobTitle;
  final String department;
  final String bankCardType;
  final String bankCardNumber;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.image,
    required this.birthDate,
    required this.gender,
    required this.bloodGroup,
    required this.height,
    required this.addressStr,
    required this.companyName,
    required this.jobTitle,
    required this.department,
    required this.bankCardType,
    required this.bankCardNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'],
      birthDate: json['birthDate'],
      gender: json['gender'],
      bloodGroup: json['bloodGroup'],
      height: (json['height'] as num).toDouble(),
      addressStr: "${json['address']['address']}, ${json['address']['city']}",
      companyName: json['company']['name'],
      jobTitle: json['company']['title'],
      department: json['company']['department'],
      bankCardType: json['bank']['cardType'],
      bankCardNumber: json['bank']['cardNumber'],
    );
  }

  String get fullName => "$firstName $lastName";
}

// ==========================================
// 2. MÀN HÌNH ĐĂNG NHẬP (LoginProfileScreen)
// ==========================================
class LoginProfileScreen extends StatefulWidget {
  const LoginProfileScreen({super.key});

  @override
  State<LoginProfileScreen> createState() => _LoginProfileScreenState();
}

class _LoginProfileScreenState extends State<LoginProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscureText = true;

  // DỮ LIỆU CỨNG (Mock Data)
  final Map<String, dynamic> mockApiResponse = {
    "id": 1,
    "firstName": "Emily",
    "lastName": "Johnson",
    "email": "emily.johnson@x.dummyjson.com",
    "phone": "+81 965-431-3024",
    "https://images.unsplash.com/photo-1701615004837-40d8573b6652?q=80&w=880&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "birthDate": "1996-5-30",
    "gender": "female",
    "bloodGroup": "O-",
    "height": 193.24,
    "address": {"address": "626 Main Street", "city": "Phoenix"},
    "company": {
      "department": "Engineering",
      "name": "Dooley, Kozey and Cronin",
      "title": "Sales Manager",
    },
    "bank": {
      "cardNumber": "3693233511855044",
      "cardType": "Diners Club International",
    },
  };

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đang đăng nhập...')));

      // Tạo object User từ dữ liệu giả
      User user = User.fromJson(mockApiResponse);

      // Chuyển sang màn hình thông tin
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserInfoPage(user: user)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5),
      appBar: AppBar(
        title: const Text(
          "Bài 11: Đăng nhập Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF9C27B0),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_circle,
                size: 80,
                color: Color(0xFF9C27B0),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email / Username",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (v) => v!.isEmpty ? "Vui lòng nhập thông tin" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: "Mật khẩu",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => _obscureText = !_obscureText),
                  ),
                ),
                validator: (v) => v!.isEmpty ? "Vui lòng nhập mật khẩu" : null,
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C27B0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "ĐĂNG NHẬP",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
// 3. MÀN HÌNH THÔNG TIN (UserInfoPage)
// ==========================================
class UserInfoPage extends StatelessWidget {
  final User user;

  const UserInfoPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    const Color headerColor = Color(0xFF9C27B0);
    const Color bgColor = Color(0xFFF3E5F5);
    const Color titleColor = Color(0xFF8E24AA);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          "Hồ sơ người dùng",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: headerColor,
        centerTitle: true,
        // Nút Back mặc định sẽ hoạt động tốt trong trang tổng hợp
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user.image),
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A148C),
                    ),
                  ),
                  Text(
                    user.jobTitle,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),

            // BODY
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildSectionCard(
                    title: "Thông tin cá nhân",
                    titleColor: titleColor,
                    children: [
                      _buildRow(Icons.cake, "Ngày sinh", user.birthDate),
                      _buildRow(Icons.person, "Giới tính", user.gender),
                      _buildRow(Icons.bloodtype, "Nhóm máu", user.bloodGroup),
                      _buildRow(Icons.height, "Chiều cao", "${user.height} cm"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSectionCard(
                    title: "Liên hệ & Địa chỉ",
                    titleColor: titleColor,
                    children: [
                      _buildRow(Icons.email, "Email", user.email),
                      _buildRow(Icons.phone, "SĐT", user.phone),
                      _buildRow(Icons.location_on, "Địa chỉ", user.addressStr),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSectionCard(
                    title: "Công việc",
                    titleColor: titleColor,
                    children: [
                      _buildRow(Icons.business, "Công ty", user.companyName),
                      _buildRow(Icons.work, "Phòng ban", user.department),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSectionCard(
                    title: "Tài chính",
                    titleColor: titleColor,
                    children: [
                      _buildRow(
                        Icons.credit_card,
                        "Loại thẻ",
                        user.bankCardType,
                      ),
                      _buildRow(Icons.numbers, "Số thẻ", user.bankCardNumber),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required Color titleColor,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            const Divider(color: Color(0xFFCE93D8), thickness: 1),
            const SizedBox(height: 5),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
