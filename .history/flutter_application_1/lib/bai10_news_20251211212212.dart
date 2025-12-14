import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ---------------------------------------------------------
// 1. MODEL (Code của bạn)
// ---------------------------------------------------------
class Article {
  final String title;
  final String description;
  final String urlToImage;
  final String url;
  final String content;

  Article({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.url,
    required this.content,
  });
}

// ---------------------------------------------------------
// 2. MÀN HÌNH DANH SÁCH TIN TỨC (NewsListScreen)
// Màn hình này sẽ hiện danh sách, bấm vào sẽ sang trang chi tiết
// ---------------------------------------------------------
class NewsListScreen extends StatelessWidget {
  const NewsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dữ liệu giả lập (Mock Data)
    final List<Article> articles = [
      Article(
        title: "Flutter 3.19 ra mắt với nhiều cải tiến AI",
        description:
            "Google vừa công bố phiên bản Flutter mới nhất với khả năng tích hợp Gemini AI mạnh mẽ.",
        urlToImage:
            "https://storage.googleapis.com/cms-storage-bucket/780e0e64d323aad2cdd5.png",
        url: "https://flutter.dev/",
        content:
            "Phiên bản này tập trung vào tối ưu hiệu năng, nâng cấp Impeller engine trên Android và tích hợp sâu Dart Google AI SDK...",
      ),
      Article(
        title: "Dart 3.3 giới thiệu Extension Types",
        description:
            "Cập nhật mới của ngôn ngữ Dart giúp lập trình viên tối ưu hóa hiệu suất và tương tác tốt hơn với JS.",
        urlToImage:
            "https://cdn-images-1.medium.com/max/1024/1*5Jv5Yagqk3i5pt-qxghfGw.png",
        url: "https://dart.dev/",
        content:
            "Extension Types là một tính năng tính năng mới giúp bọc các kiểu dữ liệu nguyên thủy mà không tốn chi phí bộ nhớ...",
      ),
      Article(
        title: "Thị trường Mobile App năm 2025",
        description:
            "Xu hướng phát triển ứng dụng di động đang dịch chuyển mạnh sang Cross-platform.",
        urlToImage:
            "https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?auto=format&fit=crop&q=80&w=1000",
        url: "https://google.com",
        content:
            "Các công nghệ như Flutter, React Native đang chiếm ưu thế nhờ khả năng tiết kiệm chi phí và thời gian phát triển...",
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tin tức công nghệ"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final item = articles[index];
          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 4,
            child: InkWell(
              onTap: () {
                // Chuyển sang màn hình chi tiết (Code của bạn)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDetailScreen(article: item),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ảnh thumbnail
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                    child: Image.network(
                      item.urlToImage,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, error, stack) => Container(
                        height: 180,
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.image, size: 50)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.description,
                          style: TextStyle(color: Colors.grey[700]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------
// 3. MÀN HÌNH CHI TIẾT (Code của bạn)
// ---------------------------------------------------------
class NewsDetailScreen extends StatelessWidget {
  final Article article;

  const NewsDetailScreen({super.key, required this.article});

  Future<void> _launchURL(BuildContext context) async {
    if (article.url.isEmpty) return;
    final Uri uri = Uri.parse(article.url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $uri');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi mở liên kết: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi Tiết Bài Viết')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage.isNotEmpty)
              Image.network(
                article.urlToImage,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (ctx, error, stackTrace) => const SizedBox(
                  height: 200,
                  child: Center(child: Icon(Icons.broken_image, size: 50)),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    article.content,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _launchURL(context),
                      icon: const Icon(Icons.open_in_browser),
                      label: const Text('Đọc bài viết gốc'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
