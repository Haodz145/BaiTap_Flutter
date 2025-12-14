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
import 'bai11_logindata.dart';

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
        // '/bai3': (context) =>
        //     const LakePage(), // Sửa tên class nếu bạn dùng PavlovaPage
        '/bai4': (context) => ChangeColorApp(),
        '/bai5': (context) => const CounterApp(),
        '/bai6': (context) => const TimerApp(),
        '/bai7': (context) => const RegistrationPage(),
        '/bai8': (context) => const LoginExercisePage(),
        '/bai9': (context) => const ProductListScreen(),
        '/bai10': (context) => const NewsListScreen(),
        '/bai11': (context) => const LoginApiScreen(),
      },
    );
  }
}

// --- MÀN HÌNH TRANG CHỦ ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cổng thông tin bài tập"),
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
              "Xin chào thầy/cô!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Đây là ứng dụng tổng hợp các bài thực hành.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                // Mở Menu bằng nút bấm (ngoài việc vuốt cạnh trái)
                Scaffold.of(context).openDrawer();
              },
              // Lưu ý: Để dùng Scaffold.of() ở đây cần Builder,
              // nhưng đơn giản nhất là hướng dẫn bấm icon góc trái trên AppBar.
              icon: const Icon(Icons.menu),
              label: const Text("Mở Menu Bài Tập (Góc trái)"),
            ),
          ],
        ),
      ),
    );
  }
}
