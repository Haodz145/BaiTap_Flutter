import 'package:flutter/material.dart';

class LayoutExercisePage extends StatelessWidget {
  const LayoutExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Giữ nội dung không bị che bởi tai thỏ/status bar
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Padding tổng thể giống Slide
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HEADER (Row chứa 2 icon bên phải)
              Row(
                mainAxisAlignment: MainAxisAlignment.end, // Đẩy sang phải
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications, color: Colors.black),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.extension, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Khoảng cách
              const Text.rich(
                TextSpan(
                  style: TextStyle(fontSize: 30, color: Colors.black),
                  children: [
                    TextSpan(
                      text: "Welcome,\n", // Xuống dòng
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "Charlie",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ), // Mặc định là normal
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search, size: 30),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15), // Bo tròn
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),

              const SizedBox(height: 40),

              // 4. TIÊU ĐỀ SAVED PLACES
              const Text(
                "Saved Places",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // 5. LƯỚI HÌNH ẢNH (GridView)
              Expanded(
                // Bắt buộc dùng Expanded khi để GridView trong Column
                child: GridView.count(
                  crossAxisCount: 2, // 2 cột
                  mainAxisSpacing: 15, // Khoảng cách dọc
                  crossAxisSpacing: 15, // Khoảng cách ngang
                  childAspectRatio: 1.5, // Tỷ lệ khung hình (ngang/dọc)
                  children: [
                    _buildImageCard(
                      "https://images.unsplash.com/photo-1524413840807-0c3cb6fa808d?auto=format&fit=crop&w=500&q=60",
                    ), // Japan
                    _buildImageCard(
                      "https://images.unsplash.com/photo-1583422409516-2895a77efded?auto=format&fit=crop&w=500&q=60",
                    ), // Barcelona
                    _buildImageCard(
                      "https://images.unsplash.com/photo-1533050487297-09b450131914?auto=format&fit=crop&w=500&q=60",
                    ), // Castle
                    _buildImageCard(
                      "https://images.unsplash.com/photo-1552832230-c0197dd311b5?auto=format&fit=crop&w=500&q=60",
                    ), // Rome
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget con để hiển thị ảnh bo góc
  Widget _buildImageCard(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15), // Bo góc ảnh
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover, // Ảnh phủ kín khung
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (context, error, stackTrace) =>
            Container(color: Colors.grey[300], child: const Icon(Icons.error)),
      ),
    );
  }
}
