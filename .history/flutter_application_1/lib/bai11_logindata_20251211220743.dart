import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// 1. MODEL: Class User (Giữ nguyên của bạn)
// ---------------------------------------------------------------------------
class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String image;
  final int age;
  final String gender;
  final String birthDate;
  final String bloodGroup;
  final double height;
  final double weight;
  final String ip;
  final String addressStr;
  final String city;
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
    required this.age,
    required this.gender,
    required this.birthDate,
    required this.bloodGroup,
    required this.height,
    required this.weight,
    required this.ip,
    required this.addressStr,
    required this.city,
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
      age: json['age'],
      gender: json['gender'],
      birthDate: json['birthDate'],
      bloodGroup: json['bloodGroup'],
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      ip: json['ip'],
      addressStr: json['address']['address'],
      city: json['address']['city'],
      companyName: json['company']['name'],
      jobTitle: json['company']['title'],
      department: json['company']['department'],
      bankCardType: json['bank']['cardType'],
      bankCardNumber: json['bank']['cardNumber'],
    );
  }

  String get fullName => "$firstName $lastName";
}

// ---------------------------------------------------------------------------
// 2. LOGIN PAGE (Giao diện nhập liệu)
// ---------------------------------------------------------------------------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Dữ liệu giả lập (Giữ nguyên cục JSON của bạn)
  final Map<String, dynamic> mockApiResponse = {
    "id": 1,
    "firstName": "Emily",
    "lastName": "Johnson",
    "maidenName": "Smith",
    "age": 29,
    "gender": "female",
    "email": "emily.johnson@x.dummyjson.com",
    "phone": "+81 965-431-3024",
    "username": "emilys",
    "password": "emilyspass",
    "birthDate": "1996-5-30",
    "image":
        "https://dummyjson.com/icon/emilys/128", // Đã sửa link ảnh ngắn gọn cho dễ hiển thị
    "bloodGroup": "O-",
    "height": 193.24,
    "weight": 63.16,
    "eyeColor": "Green",
    "hair": {"color": "Brown", "type": "Curly"},
    "ip": "42.48.100.32",
    "address": {
      "address": "626 Main Street",
      "city": "Phoenix",
      "state": "Mississippi",
      "stateCode": "MS",
      "postalCode": "29112",
      "coordinates": {"lat": -77.16213, "lng": -92.084824},
      "country": "United States",
    },
    "macAddress": "47:fa:41:18:ec:eb",
    "university": "University of Wisconsin--Madison",
    "bank": {
      "cardExpire": "05/28",
      "cardNumber": "3693233511855044",
      "cardType": "Diners Club International",
      "currency": "GBP",
      "iban": "GB74MH2UZLR9TRPHYNU8F8",
    },
    "company": {
      "department": "Engineering",
      "name": "Dooley, Kozey and Cronin",
      "title": "Sales Manager",
      "address": {
        "address": "263 Tenth Street",
        "city": "San Francisco",
        "state": "Wisconsin",
        "stateCode": "WI",
        "postalCode": "37657",
        "coordinates": {"lat": 71.814525, "lng": -161.150263},
        "country": "United States",
      },
    },
    "ein": "977-175",
    "ssn": "900-590-289",
    "userAgent": "Mozilla/5.0...",
    "crypto": {
      "coin": "Bitcoin",
      "wallet": "0xb9fc2fe63b2a6c003f1c324c3bfa53259162181a",
      "network": "Ethereum (ERC20)",
    },
    "role": "admin",
  };

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // Logic gốc của bạn: Chỉ cần validate form OK là chuyển trang
      // Không kiểm tra user/pass gì cả
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng nhập thành công! Đang tải dữ liệu...'),
        ),
      );

      Future.delayed(const Duration(seconds: 1), () {
        // Parse dữ liệu từ biến mockApiResponse ở trên
        User user = User.fromJson(mockApiResponse);

        // Chuyển sang màn hình thông tin
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserInfoPage(user: user)),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5),
      appBar: AppBar(
        title: const Text(
          "Form Đăng nhập (Bài 11)",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF9C27B0),
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
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration(
                  hintText: "Email",
                  prefixIcon: Icons.email_outlined,
                ),
                // Validate đơn giản: chỉ cần không rỗng
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Vui lòng nhập email'
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
                    ),
                    onPressed: () => setState(() => _isObscure = !_isObscure),
                  ),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Vui lòng nhập mật khẩu'
                    : null,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _handleLogin,
                  icon: const Icon(Icons.login, color: Colors.white),
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
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Color(0xFF9C27B0), width: 2),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. USER INFO PAGE (Màn hình hiển thị thông tin)
// ---------------------------------------------------------------------------
class UserInfoPage extends StatelessWidget {
  final User user;

  const UserInfoPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5),
      appBar: AppBar(
        title: const Text(
          "Hồ sơ người dùng",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF9C27B0),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(user.image),
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
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildInfoCard("Thông tin cá nhân", [
              _buildRow(Icons.cake, "Ngày sinh", user.birthDate),
              _buildRow(Icons.person, "Giới tính", user.gender),
              _buildRow(Icons.bloodtype, "Nhóm máu", user.bloodGroup),
              _buildRow(Icons.height, "Chiều cao", "${user.height} cm"),
            ]),

            const SizedBox(height: 15),

            _buildInfoCard("Liên hệ & Địa chỉ", [
              _buildRow(Icons.email, "Email", user.email),
              _buildRow(Icons.phone, "SĐT", user.phone),
              _buildRow(
                Icons.location_on,
                "Địa chỉ",
                "${user.addressStr}, ${user.city}",
              ),
            ]),

            const SizedBox(height: 15),

            _buildInfoCard("Công việc", [
              _buildRow(Icons.business, "Công ty", user.companyName),
              _buildRow(Icons.work, "Phòng ban", user.department),
            ]),

            const SizedBox(height: 15),

            _buildInfoCard("Tài chính", [
              _buildRow(Icons.credit_card, "Loại thẻ", user.bankCardType),
              _buildRow(Icons.numbers, "Số thẻ", user.bankCardNumber),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9C27B0),
              ),
            ),
            const Divider(color: Colors.purpleAccent),
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
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 10),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
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
