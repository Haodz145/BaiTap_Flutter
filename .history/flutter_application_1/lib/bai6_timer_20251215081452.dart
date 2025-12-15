import 'dart:async';
import 'package:flutter/material.dart';

class TimerApp extends StatefulWidget {
  const TimerApp({super.key});

  @override
  State<TimerApp> createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {
  final TextEditingController _controller = TextEditingController();

  int _seconds = 0;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning) return;

    if (_controller.text.isNotEmpty) {
      setState(() {
        if (_seconds == 0) {
          _seconds = int.tryParse(_controller.text) ?? 0;
        }
        _isRunning = true;
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_seconds > 0) {
          setState(() {
            _seconds--;
          });
        } else {
          _stopTimer();
        }
      });
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _seconds = 0;
      _controller.clear(); // Xóa sạch ô nhập
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(import 'package:flutter/material.dart';

// Model dữ liệu giả lập cho khách sạn
class Hotel {
  final String imageUrl;
  final String name;
  final double rating;
  final int reviewCount;
  final String location;
  final double distance;
  final String price;
  final String tag; // Ví dụ: "Bao bữa sáng"

  Hotel({
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.reviewCount,
    required this.location,
    required this.distance,
    required this.price,
    this.tag = '',
  });
}

class Bai03BookingScreen extends StatelessWidget {
  Bai03BookingScreen({super.key});

  // Danh sách dữ liệu giả (Fake Data)
  final List<Hotel> hotels = [
    Hotel(
      imageUrl: 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/467656079.jpg?k=230713797669661445763564673645834574365834756', // Ảnh demo
      name: 'aNhill Boutique',
      rating: 9.5,
      reviewCount: 95,
      location: 'Huế',
      distance: 0.6,
      price: 'US\$109',
      tag: 'Bao bữa sáng',
    ),
    Hotel(
      imageUrl: 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/41235123.jpg?k=123123',
      name: 'An Nam Hue Boutique',
      rating: 9.2,
      reviewCount: 34,
      location: 'Cư Chánh',
      distance: 0.9,
      price: 'US\$20',
      tag: 'Bao bữa sáng',
    ),
    Hotel(
      imageUrl: 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/51235123.jpg?k=5123123',
      name: 'Hue Jade Hill Villa',
      rating: 8.0,
      reviewCount: 1,
      location: 'Cư Chánh',
      distance: 1.3,
      price: 'US\$285',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange, width: 2), // Viền cam
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Xung quanh vị trí hiện tại", 
                style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)
              ),
              Text(
                "23 thg 10 - 24 thg 10", 
                style: TextStyle(color: Colors.black54, fontSize: 12)
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // 1. THANH CÔNG CỤ (Sắp xếp, Lọc, Bản đồ)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _ToolItem(icon: Icons.sort, label: "Sắp xếp"),
                _ToolItem(icon: Icons.tune, label: "Lọc"),
                _ToolItem(icon: Icons.map_outlined, label: "Bản đồ"),
              ],
            ),
          ),
          
          // 2. DÒNG THÔNG BÁO SỐ LƯỢNG
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("${hotels.length} chỗ nghỉ", style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),

          // 3. DANH SÁCH KHÁCH SẠN
          Expanded(
            child: ListView.builder(
              itemCount: hotels.length,
              itemBuilder: (context, index) {
                return _buildHotelCard(hotels[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelCard(Hotel hotel) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias, // Cắt ảnh theo bo góc
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // A. ẢNH + TAG + TIM
          Stack(
            children: [
              Image.network(
                hotel.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(
                  height: 180, 
                  color: Colors.grey[300], 
                  child: const Center(child: Icon(Icons.image, size: 50, color: Colors.grey))
                ),
              ),
              if (hotel.tag.isNotEmpty)
                Positioned(
                  top: 10, left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: Colors.green[700],
                    child: Text(hotel.tag, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              const Positioned(
                top: 10, right: 10,
                child: Icon(Icons.favorite_border, color: Colors.white, size: 28),
              ),
            ],
          ),

          // B. THÔNG TIN CHI TIẾT
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cột trái: Tên, đánh giá, vị trí
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(hotel.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      // Hàng đánh giá
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.blue[900],
                              borderRadius: BorderRadius.circular(4) // Bo góc vuông như hình
                            ),
                            child: Text(hotel.rating.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 8),
                          Text(hotel.rating >= 9.0 ? "Xuất sắc" : "Rất tốt", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                          const SizedBox(width: 4),
                          Text("• ${hotel.reviewCount} đánh giá", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Vị trí
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[700]),
                          const SizedBox(width: 4),
                          Text("${hotel.location} • Cách bạn ${hotel.distance}km", style: TextStyle(color: Colors.grey[800], fontSize: 13)),
                        ],
                      )
                    ],
                  ),
                ),
                // Cột phải: Giá
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 20),
                    Text(hotel.price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text("Đã bao gồm thuế và phí", style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// Widget phụ cho thanh công cụ
class _ToolItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ToolItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.black87),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
      appBar: AppBar(
        title: const Text("Bộ đếm thời gian"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 40),

              const Text(
                "Nhập số giây cần đếm:",
                style: TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 15),

              Container(
                width: 200,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "0",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Text(
                _formatTime(_seconds),
                style: const TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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

                  ElevatedButton(
                    onPressed: _resetTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
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
