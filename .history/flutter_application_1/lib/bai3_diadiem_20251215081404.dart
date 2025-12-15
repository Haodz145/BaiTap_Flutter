import 'package:flutter/material.dart';

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
                "Xung quanh vị