class Post {
  final String id;
  final String title;
  final String author;
  final String date;
  final String summary;
  final String content;
  final List<String> categories;

  bool isLiked;
  int likeCount;
  bool isBookMarked;

  Post({
    required this.id,
    required this.title,
    required this.author,
    required this.date,
    required this.summary,
    required this.content,
    required this.categories,
    this.isLiked = false,
    this.likeCount = 0, // Đổi mặc định về 0 cho chuẩn thực tế
    this.isBookMarked = false,
  });

  // HÀM ÁNH XẠ DỮ LIỆU TỪ FIREBASE SANG FLUTTER
  factory Post.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Post(
      id: documentId,
      title: data['title'] ?? '',
      author: data['author'] ?? 'Ẩn danh',
      date: data['date'] ?? '',
      summary: data['summary'] ?? '',
      content: data['content'] ?? '',
      // Ép kiểu an toàn từ mảng dynamic của Firebase sang List<String>
      categories: List<String>.from(data['categories'] ?? []),
      isLiked: data['isLiked'] ?? false,
      likeCount: data['likeCount'] ?? 0,
      isBookMarked: data['isBookMarked'] ?? false,
    );
  }
}

