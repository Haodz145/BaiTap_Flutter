import 'package:flutter/material.dart';

class Hotel {
  final String imageUrl;
  final String name;
  final double rating;
  final int reviewCount;
  final String location;
  final double distance;
  final String price;
  final String tag;

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

class BookingScreen extends StatelessWidget {
  BookingScreen({super.key});

  final List<Hotel> hotels = [
    Hotel(
      imageUrl:
          'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      name: 'aNhill Boutique',
      rating: 9.5,
      reviewCount: 95,
      location: 'Huế',
      distance: 0.6,
      price: 'US\$109',
      tag: 'Bao bữa sáng',
    ),
    Hotel(
      imageUrl:
          'https://cf.bstatic.com/xdata/images/hotel/max1024x768/41235123.jpg?k=123123',
      name: 'An Nam Hue Boutique',
      rating: 9.2,
      reviewCount: 34,
      location: 'Cư Chánh',
      distance: 0.9,
      price: 'US\$20',
      tag: 'Bao bữa sáng',
    ),
    Hotel(
      imageUrl:
          'https://cf.bstatic.com/xdata/images/hotel/max1024x768/51235123.jpg?k=5123123',
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
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "23 thg 10 - 24 thg 10",
                style: TextStyle(color: Colors.black54, fontSize: 12),
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
              child: Text(
                "${hotels.length} chỗ nghỉ",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
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
                  child: const Center(
                    child: Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                ),
              ),
              if (hotel.tag.isNotEmpty)
                Positioned(
                  top: 10,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    color: Colors.green[700],
                    child: Text(
                      hotel.tag,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              const Positioned(
                top: 10,
                right: 10,
                child: Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                  size: 28,
                ),
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
                      Text(
                        hotel.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Hàng đánh giá
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.blue[900],
                              borderRadius: BorderRadius.circular(
                                4,
                              ), // Bo góc vuông như hình
                            ),
                            child: Text(
                              hotel.rating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            hotel.rating >= 9.0 ? "Xuất sắc" : "Rất tốt",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "• ${hotel.reviewCount} đánh giá",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Vị trí
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${hotel.location} • Cách bạn ${hotel.distance}km",
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Cột phải: Giá
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      hotel.price,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Đã bao gồm thuế và phí",
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
