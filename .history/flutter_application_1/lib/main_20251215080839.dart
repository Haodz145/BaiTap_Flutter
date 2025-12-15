import 'package:flutter/material.dart';

// --- IMPORT MENU ---
import 'menu.dart';

// --- IMPORT CÁC BÀI TẬP (Đảm bảo tên file đúng với project của bạn) ---
import 'bai1_khoahoc.dart';
import 'bai2_layout.dart';
// import 'bai3_lake.dart'; // Hoặc bai3_pavlova.dart
import 'bai4_doimau.dart';
import 'bai5_counter.dart';
import 'bai6_timer.dart';
import 'bai7_dangky.dart';
import 'bai8_dangnhap.dart';
import 'bai9_product.dart';
import 'bai10_news.dart';
import 'bai11_login_data.dart';

void main() {
  runApp(const MyHomeworkApp());
}

class MyHomeworkApp extends StatelessWidget {
  const MyHomeworkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tổng hợp Bài tập Flutter',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),

      // --- BẢN ĐỒ ĐƯỜNG DẪN (ROUTES) ---
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/bai1': (context) => const CourseListScreen(),
        '/bai2': (context) => const LayoutExercisePage(),
        '/bai4': (context) => ChangeColorApp(),
        '/bai5': (context) => const CounterApp(),
        '/bai6': (context) => const TimerApp(),
        '/bai7': (context) => const RegistrationPage(),
        '/bai8': (context) => const LoginExercisePage(),
        '/bai9': (context) => const ProductListScreen(),
        '/bai10': (context) => const NewsListScreen(),
        '/bai11': (context) => const LoginProfileScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách bài tập"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      // Gắn Menu vào trang chủ
      drawer: const AppDrawer(),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.folder_special,
              size: 100,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 20),
            const Text(
              "Nguyễn Nhật Hào",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Mã SV: 22T1020105",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
