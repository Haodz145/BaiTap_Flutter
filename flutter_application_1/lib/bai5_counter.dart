import 'package:flutter/material.dart';

class CounterApp extends StatefulWidget {
  const CounterApp({super.key});

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  // Biến đếm số, khởi tạo bằng 0 (hoặc 5 nếu muốn giống ảnh ngay lúc đầu)
  int _count = 0;

  // Hàm giảm số
  void _decrement() {
    setState(() {
      _count--;
    });
  }

  // Hàm tăng số
  void _increment() {
    setState(() {
      _count++;
    });
  }

  // Hàm đặt lại về 0
  void _reset() {
    setState(() {
      _count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ứng dụng Đếm số"),
        centerTitle: true, // Căn giữa tiêu đề giống ảnh
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Số hiện tại:",
              style: TextStyle(fontSize: 24, color: Colors.black54),
            ),
            const SizedBox(height: 10),

            // Con số hiển thị
            Text(
              "$_count",
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                // Logic đổi màu: Số dương màu xanh, số âm màu đỏ (tùy chọn), hoặc luôn xanh như ảnh
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 40),

            // Hàng chứa 3 nút bấm
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Nút GIẢM (Màu đỏ)
                ElevatedButton.icon(
                  onPressed: _decrement,
                  icon: const Icon(Icons.remove),
                  label: const Text("Giảm"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Nền đỏ
                    foregroundColor: Colors.white, // Chữ trắng
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),

                const SizedBox(width: 20), // Khoảng cách giữa các nút
                // Nút ĐẶT LẠI (Màu xám)
                ElevatedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Đặt lại"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, // Nền xám
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                // Nút TĂNG (Màu xanh)
                ElevatedButton.icon(
                  onPressed: _increment,
                  icon: const Icon(Icons.add),
                  label: const Text("Tăng"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Nền xanh
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
