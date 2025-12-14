import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// =========================================================
// 1. MODEL: Cấu trúc một bài báo
// =========================================================
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

// =========================================================
// 2. DỮ LIỆU MẪU (MOCK DATA)
// =========================================================
final List<Article> myNewsList = [
  Article(
    title: "Ra mắt iPhone 16 Pro Max: Đỉnh cao công nghệ",
    description:
        "Apple vừa chính thức giới thiệu dòng iPhone mới với nút Capture Button và chip A18 Pro cực mạnh.",
    urlToImage: "https://picsum.photos/id/1/600/300",
    url: "https://www.apple.com/",
    content:
        "iPhone 16 Pro Max sở hữu viền màn hình mỏng nhất lịch sử, camera zoom quang 5x cải tiến và thời lượng pin vượt trội. Nút Capture Button mới cho phép quay chụp chuyên nghiệp hơn...",
  ),
  Article(
    title: "AI đang thay đổi cách chúng ta làm việc thế nào?",
    description:
        "Trí tuệ nhân tạo không thay thế con người, nhưng người biết dùng AI sẽ thay thế người không biết.",
    urlToImage: "https://picsum.photos/id/60/600/300",
    url: "https://openai.com/",
    content:
        "Từ việc viết code, thiết kế ảnh cho đến soạn email, các công cụ như ChatGPT và Midjourney đang tăng hiệu suất làm việc lên gấp nhiều lần. Các doanh nghiệp đang ráo riết tuyển dụng nhân sự có kỹ năng AI...",
  ),
  Article(
    title: "Top 10 địa điểm du lịch 'chữa lành' năm 2025",
    description:
        "Bỏ lại khói bụi thành phố, hãy đến với những vùng đất bình yên này để tái tạo năng lượng.",
    urlToImage: "https://picsum.photos/id/57/600/300",
    url: "https://vietnam.travel/",
    content:
        "Hà Giang, Măng Đen hay những hòn đảo hoang sơ tại Phú Quý đang là điểm đến yêu thích của giới trẻ. Xu hướng du lịch chậm (slow travel) đang lên ngôi...",
  ),
  Article(
    title: "Thị trường xe điện: Cuộc đua của những gã khổng lồ",
    description:
        "VinFast, Tesla và BYD đang cạnh tranh khốc liệt để giành thị phần xe xanh.",
    urlToImage: "https://picsum.photos/id/111/600/300",
    url: "https://tesla.com/",
    content:
        "Với xu hướng bảo vệ môi trường, xe điện đang dần thay thế xe xăng. Các trạm sạc đang được phủ sóng rộng rãi, giúp người dùng an tâm hơn trong những chuyến đi xa...",
  ),
  Article(
    title: "Bí quyết sống khỏe của người Nhật",
    description:
        "Tại sao Nhật Bản luôn nằm trong top những quốc gia có tuổi thọ cao nhất thế giới?",
    urlToImage: "https://picsum.photos/id/225/600/300",
    url: "https://www.who.int/",
    content:
        "Chế độ ăn nhiều cá, ít thịt đỏ, uống trà xanh và thói quen đi bộ hàng ngày là những bí quyết đơn giản nhưng hiệu quả. Ngoài ra, tinh thần Ikigai cũng giúp họ sống vui vẻ mỗi ngày...",
  ),
];

// =========================================================
// 3. MÀN HÌNH DANH SÁCH (NEWS FEED)
// =========================================================
class NewsListScreen extends StatelessWidget {
  const NewsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tin Tức Mới Nhất"),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: myNewsList.length,
        itemBuilder: (context, index) {
          final item = myNewsList[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 20),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                // Chuyển sang màn hình Chi tiết
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
                  // Ảnh bài viết
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child: Image.network(
                      item.urlToImage,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, error, stack) => Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 200,
                          color: Colors.grey[100],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    ),
                  ),

                  // Nội dung tóm tắt
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.description,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 15),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Đọc thêm",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: Colors.blue,
                            ),
                          ],
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

// =========================================================
// 4. MÀN HÌNH CHI TIẾT (DETAIL SCREEN)
// =========================================================
class NewsDetailScreen extends StatelessWidget {
  final Article article;

  const NewsDetailScreen({super.key, required this.article});

  // Hàm mở trình duyệt
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
        ).showSnackBar(SnackBar(content: Text('Không thể mở liên kết: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nội Dung Chi Tiết'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh bìa
            Image.network(
              article.urlToImage,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (ctx, error, stackTrace) => Container(
                height: 250,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.broken_image, size: 50)),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Mô tả in nghiêng
                  Text(
                    article.description,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(thickness: 1),
                  const SizedBox(height: 20),

                  // Nội dung chính
                  Text(
                    article.content,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Nút mở trình duyệt
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => _launchURL(context),
                      icon: const Icon(Icons.language),
                      label: const Text('Xem bài viết gốc (Web)'),
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
