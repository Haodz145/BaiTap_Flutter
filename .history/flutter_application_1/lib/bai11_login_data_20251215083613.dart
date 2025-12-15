import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String website;
  final String companyName;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.website,
    required this.companyName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? 'No Name',
      email: json['email'] ?? 'No Email',
      phone: json['phone'] ?? '',
      website: json['website'] ?? '',
      companyName: json['company'] != null ? json['company']['name'] : 'Free',
    );
  }
}

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class UserScreenState extends State<UserScreen> {
  List<User> _users = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  // Hàm gọi API
  Future<void> _fetchUsers() async {
    final url = 'https://jsonplaceholder.typicode.com/users';

    try {
      final dio = Dio();
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        // API trả về một List [], ta ép kiểu nó thành List<dynamic>
        List<dynamic> data = response.data;

        setState(() {
          // Chuyển đổi từng cục JSON thành object User
          _users = data.map((json) => User.fromJson(json)).toList();
          _isLoading = false; // Tắt vòng xoay loading
        });
      } else {
        setState(() {
          _errorMessage = "Lỗi server: ${response.statusCode}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Lỗi kết nối: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Danh Bạ Online (API)"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
                _users.clear();
              });
              _fetchUsers();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Đang tải...
          : _errorMessage.isNotEmpty
          ? Center(
              child: Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ) // Có lỗi...
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return _buildUserCard(user);
              },
            ),
    );
  }

  Widget _buildUserCard(User user) {
    final avatarColor = Colors.primaries[user.id % Colors.primaries.length];

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: avatarColor,
          child: Text(
            user.name[0],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        title: Text(
          user.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            _buildIconText(Icons.email, user.email),
            const SizedBox(height: 3),
            _buildIconText(Icons.phone, user.phone),
            const SizedBox(height: 3),
            _buildIconText(Icons.business, user.companyName),
          ],
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: () {
          // Xử lý khi bấm vào (ví dụ hiện chi tiết)
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Đã chọn: ${user.name}")));
        },
      ),
    );
  }

  // Widget phụ để vẽ dòng icon + text nhỏ
  Widget _buildIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.indigoAccent),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            overflow: TextOverflow.ellipsis, // Nếu dài quá thì hiện ...
          ),
        ),
      ],
    );
  }
}
