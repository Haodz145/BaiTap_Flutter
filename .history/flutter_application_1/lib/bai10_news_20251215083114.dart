import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

// =========================================================
// 1. MODEL: Cấu trúc dữ liệu bài báo
// =========================================================
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
      description: json['description'] ?? 'Không có mô tả chi tiết',
      urlToImage: json['urlToImage'],
      url: json['url'],
      content: json['content'],
      publishedAt: json['publishedAt'],
      sourceName: json['source'] != null ? json['source']['name'] : 'NewsAPI',
    );
  }
}

// =========================================================
// 2. MÀN HÌNH DANH SÁCH TIN TỨC
// =========================================================
class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  List<Article> _articles = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    String url =
        'https://newsapi.org/v2/everything?q=bitcoin&sortBy=publishedAt&apiKey=1e65d2ff6bd64e6cb84fe613006adf49';
    try {
      var dio = Dio();
      var response = await dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> listJson = response.data['articles'];
        setState(() {
          _articles = listJson.map((json) => Article.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Lỗi: ${response.statusCode}";
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

  String _getRandomImageUrl(String seed) {
    return 'https://picsum.photos/seed/${seed.hashCode}/600/300';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tin Tức "),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.whie,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _articles.length,
              itemBuilder: (context, index) {
                final article = _articles[index];
                return _buildNewsCard(article);
              },
            ),
    );
  }

  Widget _buildNewsCard(Article article) {
    // Nếu API không trả về link ảnh -> Dùng ảnh random ngay lập tức
    String finalImageUrl =
        article.urlToImage ?? _getRandomImageUrl(article.title ?? 'news');

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetailScreen(article: article),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- ẢNH BÀI VIẾT ---
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                finalImageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                // Thêm User-Agent để tránh bị chặn
                headers: const {'User-Agent': 'Mozilla/5.0'},

                // Khi đang tải
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 180,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },

                // QUAN TRỌNG: Khi ảnh lỗi -> Load ảnh Random thay thế
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    _getRandomImageUrl(article.title ?? 'error'),
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),

            // Nội dung chữ
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                  const SizedBox(height: 8),
                  Text(
                    article.description ?? '',
                    style: const TextStyle(color: Colors.grey),
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
  }
}

// =========================================================
// 3. MÀN HÌNH CHI TIẾT
// =========================================================
class NewsDetailScreen extends StatelessWidget {
  final Article article;

  const NewsDetailScreen({super.key, required this.article});

  // Hàm tạo link ảnh random (dùng lại logic cũ)
  String _getRandomImageUrl(String seed) {
    return 'https://picsum.photos/seed/${seed.hashCode}/800/400';
  }

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
    // Xác định link ảnh: Nếu null thì lấy ảnh random luôn
    String finalImageUrl =
        article.urlToImage ?? _getRandomImageUrl(article.title ?? 'detail');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi Tiết"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh bìa chi tiết
            Image.network(
              finalImageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              headers: const {'User-Agent': 'Mozilla/5.0'},
              // Nếu ảnh gốc lỗi -> Load ảnh random
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  _getRandomImageUrl(article.title ?? 'detail_error'),
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Ngày đăng: ${article.publishedAt?.substring(0, 10) ?? '...'}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    article.content ??
                        article.description ??
                        'Không có nội dung',
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _launchURL,
                      icon: const Icon(Icons.public),
                      label: const Text("Xem bài viết gốc"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
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
