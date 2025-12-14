import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CourseListScreen(),
    ),
  );
}

class Course {
  final String title;
  final String code;
  final int studentCount;
  final Color backgroundColor;
  final IconData icon;
  Course({
    required this.title,
    required this.code,
    required this.studentCount,
    required this.backgroundColor,
    required this.icon,
  });
}

class CourseListScreen extends StatelessWidget {
  const CourseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Course> courses = [
      Course(
        title: "XML và ứng dụng - Nhóm 1",
        code: "2025-2026.1.TIN4583.001",
        studentCount: 58,
        backgroundColor: const Color(0xFF37474F),
        icon: Icons.emoji_events,
      ),
      Course(
        title: "Lập trình ứng dụng cho các thiết bị di động",
        code: "2025-2026.1.TIN4403.006",
        studentCount: 55,
        backgroundColor: const Color(0xFF455A64),
        icon: Icons.book,
      ),
      Course(
        title: "Lập trình ứng dụng cho các thiết bị di động",
        code: "2025-2026.1.TIN4403.005",
        studentCount: 52,
        backgroundColor: const Color(0xFF455A64),
        icon: Icons.book,
      ),
      Course(
        title: "Lập trình ứng dụng cho các thiết bị di động",
        code: "2025-2026.1.TIN4403.004",
        studentCount: 50,
        backgroundColor: const Color(0xFF1976D2),
        icon: Icons.school,
      ),
      Course(
        title: "Lập trình ứng dụng cho các thiết bị di động",
        code: "2025-2026.1.TIN4403.003",
        studentCount: 52,
        backgroundColor: const Color(0xFF37474F),
        icon: Icons.emoji_events,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Khóa học của tôi",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_circle,
              color: Colors.grey,
              size: 30,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return _buildCourseCard(courses[index]);
        },
      ),
    );
  }

  Widget _buildCourseCard(Course course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 140,
      decoration: BoxDecoration(
        color: course.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              course.icon,
              size: 140,
              color: Colors.white.withOpacity(0.1), // Làm mờ
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        course.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.more_horiz, color: Colors.white),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  course.code,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),

                const Spacer(),
                const Divider(color: Colors.white24, height: 20),
                Text(
                  "${course.studentCount} học viên",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
