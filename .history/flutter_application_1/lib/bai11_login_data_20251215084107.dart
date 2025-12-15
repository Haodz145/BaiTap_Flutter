import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

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

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => UserScreen();
}

class Ú extends State<UserScreen> {
  UserProfile? _user;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final url = 'https://dummyjson.com/users/2';

    try {
      final dio = Dio();
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        setState(() {
          _user = UserProfile.fromJson(response.data);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Lỗi: ${response.statusCode}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Lỗi kết nối mạng!";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50, // Nền hồng nhạt
      appBar: AppBar(
        title: const Text("Hồ sơ người dùng (API)"),
        backgroundColor: Colors.purple, // Màu tím đậm
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _isLoading = true);
              _fetchUserData(); // Tải lại
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.purple))
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // 1. HEADER (AVATAR + TÊN)
                  const SizedBox(height: 10),
                  CircleAvatar(
                    radius: 50,
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
                    _user!.title, // Chức vụ lấy từ API
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),

                  // 2. CÁC CARD THÔNG TIN CHI TIẾT

                  // Card: Thông tin cá nhân
                  _buildInfoCard(
                    title: "Thông tin cá nhân",
                    children: [
                      _buildRowInfo(Icons.cake, "Ngày sinh", _user!.birthDate),
                      _buildRowInfo(
                        Icons.person_outline,
                        "Giới tính",
                        _user!.gender,
                      ),
                      _buildRowInfo(
                        Icons.water_drop,
                        "Nhóm máu",
                        _user!.bloodGroup,
                      ),
                      _buildRowInfo(
                        Icons.height,
                        "Chiều cao",
                        "${_user!.height} cm",
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Card: Liên hệ & Địa chỉ
                  _buildInfoCard(
                    title: "Liên hệ & Địa chỉ",
                    children: [
                      _buildRowInfo(Icons.email, "Email", _user!.email),
                      _buildRowInfo(Icons.phone, "SĐT", _user!.phone),
                      _buildRowInfo(
                        Icons.location_on,
                        "Địa chỉ",
                        _user!.address,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Card: Công việc
                  _buildInfoCard(
                    title: "Công việc",
                    children: [
                      _buildRowInfo(
                        Icons.business,
                        "Công ty",
                        _user!.companyName,
                      ),
                      _buildRowInfo(Icons.work, "Phòng ban", _user!.department),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Card: Tài chính
                  _buildInfoCard(
                    title: "Tài chính",
                    children: [
                      _buildRowInfo(
                        Icons.credit_card,
                        "Loại thẻ",
                        _user!.cardType,
                      ),
                      _buildRowInfo(
                        Icons.numbers,
                        "Số thẻ",
                        "**** **** **** ${_user!.cardNumber.substring(_user!.cardNumber.length - 4)}",
                      ), // Ẩn bớt số thẻ
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  // --- WIDGET KHUNG CARD ---
  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
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
                color: Colors.purple,
              ),
            ),
            Divider(color: Colors.purple[100], thickness: 1),
            const SizedBox(height: 5),
            ...children,
          ],
        ),
      ),
    );
  }

  // --- WIDGET DÒNG THÔNG TIN ---
  Widget _buildRowInfo(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Căn lề trên nếu text dài
        children: [
          Icon(icon, color: Colors.grey[600], size: 22),
          const SizedBox(width: 15),
          SizedBox(
            width: 90, // Chiều rộng cố định cho nhãn
            child: Text(
              label,
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
