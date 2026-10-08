class Comment {
  final String id;
  final String postId;
  final String? parentId; 
  final String author;
  final String content;
  final String date;
  int likeCount;
  List<Comment>? replies; // Danh sách này sẽ được Provider lấp đầy sau

  Comment({
    required this.id,
    required this.postId,
    this.parentId,
    required this.author,
    required this.content,
    required this.date,
    this.likeCount = 0,
    this.replies,
  });

  factory Comment.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Comment(
      id: documentId,
      postId: data['postId'] ?? '',
      parentId: data['parentId'], // Có thể null nếu là bình luận gốc
      author: data['author'] ?? 'Ẩn danh',
      content: data['content'] ?? '',
      date: data['date'] ?? '',
      likeCount: data['likeCount'] ?? 0,
      replies: [], 
    );
  }
}

