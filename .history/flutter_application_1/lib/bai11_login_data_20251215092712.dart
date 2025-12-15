import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class UserProfile {
  final String firstName, lastName, image, title, email, phone, address;
  final String birthDate, gender, bloodGroup;
  final double height;
  final String companyName, department;
  final String cardType, cardNumber;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.title,
    required this.email,
    required this.phone,
    required this.address,
    required this.birthDate,
    required this.gender,
    required this.bloodGroup,
    required this.height,
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
      email: json['email'],
      phone: json['phone'],
      address: "${json['address']['address']}, ${json['address']['city']}",
      birthDate: json['birthDate'],
      gender: json['gender'],
      bloodGroup: json['bloodGroup'],
      height: (json['height'] as num).toDouble(),
      companyName: json['company']['name'],
      department: json['company']['department'],
      cardType: json['bank']['cardType'],
      cardNumber: json['bank']['cardNumber'],
    );
  }
}

class Bai11ProfileScreen extends StatelessWidget {
  final int userId;
  const Bai11ProfileScreen({super.key, required this.userId});

  Widget _buildRowInfo(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 15),
          SizedBox(
            width: 100,
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

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF9C27B0),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(color: Color(0xFFE1BEE7), thickness: 1, height: 20),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5),
      appBar: AppBar(
        title: const Text(
          "Hồ sơ người dùng",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF9C27B0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: Dio().get('https://dummyjson.com/users/$userId'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF9C27B0)),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("Không có dữ liệu"));
          }

          final user = UserProfile.fromJson(snapshot.data!.data);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user.image),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${user.firstName} ${user.lastName}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A148C),
                        ),
                      ),
                      Text(
                        user.title,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildSectionCard(
                  title: "Thông tin cá nhân",
                  children: [
                    _buildRowInfo(Icons.cake, "Ngày sinh", user.birthDate),
                    _buildRowInfo(Icons.person, "Giới tính", user.gender),
                    _buildRowInfo(Icons.bloodtype, "Nhóm máu", user.bloodGroup),
                    _buildRowInfo(
                      Icons.height,
                      "Chiều cao",
                      "${user.height} cm",
                    ),
                  ],
                ),
                _buildSectionCard(
                  title: "Liên hệ & Địa chỉ",
                  children: [
                    _buildRowInfo(Icons.email, "Email", user.email),
                    _buildRowInfo(Icons.phone, "SĐT", user.phone),
                    _buildRowInfo(Icons.location_on, "Địa chỉ", user.address),
                  ],
                ),
                _buildSectionCard(
                  title: "Công việc",
                  children: [
                    _buildRowInfo(Icons.business, "Công ty", user.companyName),
                    _buildRowInfo(Icons.work, "Phòng ban", user.department),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// 3. LOGIN SCREEN (ĐÃ TẮT CHECK MẬT KHẨU)
// ==========================================
class Bai11LoginPage extends StatefulWidget {
  const Bai11LoginPage({super.key});

  @override
  State<Bai11LoginPage> createState() => _Bai11LoginPageState();
}

class _Bai11LoginPageState extends State<Bai11LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
    );
  }

  // --- HÀM LOGIN GIẢ LẬP ---
  Future<void> _handleLogin() async {
    // Chỉ kiểm tra xem đã nhập chưa (nếu bạn muốn cho để trống luôn thì bỏ dòng if này đi)
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Giả vờ đợi 1 giây cho giống đang xử lý
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      // Tắt loading
      setState(() => _isLoading = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Bai11ProfileScreen(userId: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5),
      appBar: AppBar(
        title: const Text(
          "Đăng nhập",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF9C27B0),
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
              TextFormField(
                controller: _emailController,
                decoration: _inputDecoration(
                  hintText: "Tài khoản",
                  prefixIcon: Icons.email_outlined,
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Vui lòng nhập tài khoản'
                    : null,
              ),
              const SizedBox(height: 20),
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
                    onPressed: () => setState(() => _isObscure = !_isObscure),
                  ),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Vui lòng nhập mật khẩu'
                    : null,
              ),
              const SizedBox(height: 40),

              // --- Nút Đăng nhập ---
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _handleLogin,
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
