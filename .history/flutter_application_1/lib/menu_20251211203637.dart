import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.person, size: 50, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  "Sinh Viên Demo",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Trang chủ'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('Bài 1: Khóa học'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/bai1');
            },
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Bài 2: Layout'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/bai2');
            },
          ),
          // ... các bài trước
          ListTile(
            leading: const Icon(Icons.color_lens, color: Colors.purple),
            title: const Text('Bài 4: Đổi màu nền'),
            subtitle: const Text('StatefulWidget & Random'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/bai4'); // Gọi route /bai4
            },
          ),
        ],
      ),
    );
  }
}
