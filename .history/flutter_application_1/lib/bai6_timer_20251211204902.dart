import 'dart:async'; // Thư viện để dùng Timer
import 'package:flutter/material.dart';

class TimerApp extends StatefulWidget {
  const TimerApp({super.key});

  @override
  State<TimerApp> createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {
  // Controller để lấy số giây từ ô nhập
  final TextEditingController _controller = TextEditingController();

  // Biến đếm thời gian (giây)
  int _seconds = 0;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void dispose() {
    _timer?.cancel(); // Hủy timer khi thoát màn hình để tránh lỗi
    _controller.dispose();
    super.dispose();
  }

  // Hàm bắt đầu đếm
  void _startTimer() {
    // Nếu đang chạy thì không làm gì cả
    if (_isRunning) return;

    // Lấy số từ ô nhập liệu
    if (_controller.text.isNotEmpty) {
      setState(() {
        // Nếu _seconds đang là 0 (hoặc vừa reset), thì lấy giá trị mới từ ô nhập
        if (_seconds == 0) {
          _seconds = int.tryParse(_controller.text) ?? 0;
        }
        _isRunning = true;
      });

      // Tạo bộ đếm: Chạy mỗi 1 giây
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_seconds > 0) {
          setState(() {
            _seconds--;
          });
        } else {
          // Hết giờ
          _stopTimer();
        }
      });
    }
  }

  // Hàm dừng đếm (khi hết giờ hoặc muốn pause - ở bài này ta dùng để stop logic)
  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  // Hàm đặt lại (Reset)
  void _resetTimer() {
    _stopTimer();
    setState(() {
      _seconds = 0;
      _controller.clear(); // Xóa ô nhập liệu
    });
  }

  // Hàm chuyển đổi giây thành chuỗi 00:00
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    // padLeft(2, '0') để luôn hiện 2 chữ số (ví dụ 05 thay vì 5)
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bộ đếm thời gian"),
        centerTitle: true,
        backgroundColor: Colors.blue, // Màu xanh giống ảnh
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        // Cho phép cuộn để không bị che khi bàn phím hiện
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Text hướng dẫn
              const Text(
                "Nhập số giây cần đếm:",
                style: TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 15),

              // Ô nhập liệu
              Container(
                width: 200, // Giới hạn chiều rộng cho giống ảnh
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center, // Căn giữa số nhập vào
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "100",
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Đồng hồ hiển thị (Màu xanh lá)
              Text(
                _formatTime(_seconds),
                style: const TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: Colors.green, // Màu xanh lá giống ảnh
                ),
              ),

              const SizedBox(height: 40),

              // Hai nút bấm
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Nút BẮT ĐẦU (Màu cam)
                  ElevatedButton(
                    onPressed: _startTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Bắt đầu",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Nút ĐẶT LẠI (Màu đen/xám)
                  ElevatedButton(
                    onPressed: _resetTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Hoặc Colors.grey[800]
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Đặt lại",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
