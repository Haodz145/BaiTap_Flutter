import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // Import Dio
import 'package:url_launcher/url_launcher.dart';

// ---------------------------------------------------------------------------
// 1. MODEL: Cấu trúc bài viết (Parse từ JSON của NewsAPI)
// ---------------------------------------------------------------------------
class Article {
  final String? title;
  final String? description;
  final String? urlToImage;
  final String? url;
  final String? content;
  final String? publishedAt;
  final String? sourceName;

  Article({
    this.title,
    this.description,
    this.urlToImage,
    this.url,
    this.content,
    this.publishedAt,
    this.sourceName,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'Không có tiêu đề',
      description: json['description'] ?? 'Không có mô tả',
      urlToImage: json['urlToImage'], // Link ảnh có thể null
      url: json['url'],
      content: json['content'],
      publishedAt: json['publishedAt'],
      sourceName: json['source'] != null ? json['source']['name'] : 'NewsAPI',
    );
  }
}

// ---------------------------------------------------------------------------
// 2. MÀN HÌNH DANH SÁCH (Gọi API ở đây)
// ---------------------------------------------------------------------------
class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  List<Article> _articles = [];
  bool _isLoading = true; // Biến trạng thái đang tải
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchNews(); // Gọi hàm lấy tin ngay khi mở màn hình
  }

  // Hàm gọi API bằng DIO (Theo code mẫu bạn gửi)
  Future<void> _fetchNews() async {
    var dio = Dio();

    // URL API (Lưu ý: Ngày tháng đang fix cứng, bạn có thể chỉnh lại nếu muốn tin mới hơn)
    String url =
        'https://newsapi.org/v2/everything?q=apple&from=2025-11-30&to=2025-11-30&sortBy=popularity&apiKey=1e65d2ff6bd64e6cb84fe613006adf49';

    try {
      var response = await dio.request(url, options: Options(method: 'GET'));

      if (response.statusCode == 200) {
        // Lấy danh sách bài viết từ JSON trả về
        final Map<String, dynamic> data = response.data;
        final List<dynamic> listJson = data['articles'];

        setState(() {
          _articles = listJson.map((json) => Article.fromJson(json)).toList();
          _isLoading = false; // Tắt xoay vòng
        });
      } else {
        setState(() {
          _errorMessage = "Lỗi server: ${response.statusMessage}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Lỗi kết nối: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bài 10: Tin tức (API)"),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            ) // Hiển thị vòng xoay khi đang tải
          : _errorMessage.isNotEmpty
          ? Center(
              child: Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _articles.length,
              itemBuilder: (context, index) {
                final article = _articles[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  elevation: 4,
                  child: InkWell(
                    onTap: () {
                      // Bấm vào thì chuyển sang màn hình chi tiết
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NewsDetailScreen(article: article),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ảnh Thumbnail
                        if (article.urlToImage != null)
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                            child: Image.network(
                              article.urlToImage!,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => Container(
                                height: 180,
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image),
                              ),
                            ),
                          ),

                        // Tiêu đề & Mô tả
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.title ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                article.description ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
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

// ---------------------------------------------------------------------------
// 3. MÀN HÌNH CHI TIẾT (Hiển thị nội dung đầy đủ)
// ---------------------------------------------------------------------------
class NewsDetailScreen extends StatelessWidget {
  final Article article;

  const NewsDetailScreen({super.key, required this.article});

  // Hàm mở link gốc
  Future<void> _launchURL() async {
    if (article.url != null) {
      final Uri uri = Uri.parse(article.url!);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Không thể mở link $uri');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết bài viết"),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh bìa
            if (article.urlToImage != null)
              Image.network(
                article.urlToImage!,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => const SizedBox(height: 200),
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nguồn tin
                  Text(
                    "Nguồn: ${article.sourceName}",
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Tiêu đề lớn
                  Text(
                    article.title ?? '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nội dung
                  Text(
                    article.content ??
                        article.description ??
                        'Không có nội dung.',
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 30),

                  // Nút đọc bản gốc
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _launchURL,
                      icon: const Icon(Icons.public),
                      label: const Text("Xem bài viết gốc (Web)"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
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
