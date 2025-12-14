import 'package:flutter/material.dart';

// --- IMPORT CÁC FILE ĐÃ TẠO ---
import 'menu.dart'; // Để dùng được AppDrawer
import 'bai1_khoahoc.dart'; // Để dùng được CourseListScreen
import 'bai2_layout.dart'; // Để dùng được LayoutExercisePage

void main() {
  runApp(const MyHomeworkApp());
}

class MyHomeworkApp extends StatelessWidget {
  const MyHomeworkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // ĐỊNH NGHĨA ROUTE
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/bai1': (context) =>
            const CourseListScreen(), // Lấy từ file bai1_khoahoc.dart
        '/bai2': (context) =>
            const LayoutExercisePage(), // Lấy từ file bai2_layout.dart
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trang chủ bài tập")),
      drawer: const AppDrawer(), // Lấy từ file menu.dart
      body: const Center(child: Text("Mở Menu bên trái để chọn bài tập!")),
    );
  }
}
