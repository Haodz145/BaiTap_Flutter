import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // Thư viện gọi API
import 'package:url_launcher/url_launcher.dart'; // Thư viện mở trình duyệt

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

  // Hàm chuyển đổi JSON từ API thành Object
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'Không có tiêu đề',
      description: json['description'] ?? 'Không có mô tả chi tiết',
      urlToImage: json['urlToImage'], // Có thể null
      url: json['url'],
      content: json['content'],
      publishedAt: json['publishedAt'],
      sourceName: json['source'] != null ? json['source']['name'] : 'NewsAPI',
    );
  }
}

// =========================================================
// 2. MÀN HÌNH DANH SÁCH TIN TỨC (NewsListScreen)
// =========================================================
class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  List<Article> _articles = [];
  bool _isLoading = true; // Biến để hiện vòng quay loading
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchNews(); // Gọi API ngay khi mở màn hình
  }

  // Hàm gọi API sử dụng DIO
  Future<void> _fetchNews() async {
    var dio = Dio();

    // URL API lấy tin tức về Apple
    // Lưu ý: Mình bỏ bớt tham số ngày tháng (from/to) để đảm bảo luôn lấy được tin mới nhất
    // NewsAPI gói Free chỉ cho lấy tin trong vòng 1 tháng
    String url =
        'https://newsapi.org/v2/everything?q=apple&sortBy=popularity&apiKey=1e65d2ff6bd64e6cb84fe613006adf49';

    try {
      var response = await dio.request(url, options: Options(method: 'GET'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final List<dynamic> listJson = data['articles'];

        setState(() {
          _articles = listJson.map((json) => Article.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Lỗi tải dữ liệu: ${response.statusMessage}";
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
        title: const Text("Tin Tức Apple (API)"),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Đang tải
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage)) // Có lỗi
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

  // Widget hiển thị thẻ bài viết
  Widget _buildNewsCard(Article article) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Chuyển sang màn hình chi tiết
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
            // --- ẢNH BÀI VIẾT (Đã xử lý lỗi ảnh) ---
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                article.urlToImage ??
                    '', // Nếu null thì truyền chuỗi rỗng để vào errorBuilder
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,

                // Hiển thị khi đang tải ảnh
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 180,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },

                // Hiển thị khi ảnh bị lỗi hoặc không có ảnh
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    color: Colors.grey[300], // Màu nền xám
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.newspaper, size: 40, color: Colors.grey),
                        SizedBox(height: 5),
                        Text(
                          "Không có ảnh minh họa",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // --- NỘI DUNG TÓM TẮT ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title ?? 'Không có tiêu đề',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.description ?? '',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
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
// 3. MÀN HÌNH CHI TIẾT (NewsDetailScreen)
// =========================================================
class NewsDetailScreen extends StatelessWidget {
  final Article article;

  const NewsDetailScreen({super.key, required this.article});

  // Hàm mở trình duyệt
  Future<void> _launchURL() async {
    if (article.url != null) {
      final Uri uri = Uri.parse(article.url!);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Không thể mở liên kết: $uri');
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
            // Ảnh bìa lớn (Cũng xử lý lỗi ảnh)
            Image.network(
              article.urlToImage ?? '',
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 250,
                color: Colors.grey[300],
                width: double.infinity,
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nguồn tin
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Text(
                          article.sourceName ?? 'News',
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.redAccent,
                      ),
                      if (article.publishedAt != null)
                        Text(
                          article.publishedAt!.substring(
                            0,
                            10,
                          ), // Lấy ngày YYYY-MM-DD
                          style: const TextStyle(color: Colors.grey),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Tiêu đề
                  Text(
                    article.title ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nội dung
                  Text(
                    article.content ??
                        article.description ??
                        'Không có nội dung chi tiết.',
                    style: const TextStyle(fontSize: 16, height: 1.6),
                  ),

                  const SizedBox(height: 30),

                  // Nút mở web
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _launchURL,
                      icon: const Icon(Icons.language),
                      label: const Text("Đọc toàn bộ bài viết (Web)"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
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
