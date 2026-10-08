class Comment {
  final String id;
  final String postId;
  final String author;
  final String content;
  final String date;

  bool isLiked;
  int likeCount;

  final String?
      parentId; // Nếu null -> Comment cấp 1. Nếu có ID -> Là Reply cho comment đó
  List<Comment> replies; // Danh sách các câu trả lời trực tiếp cho comment này

  Comment({
    required this.id,
    required this.postId,
    required this.author,
    required this.content,
    required this.date,
    this.isLiked = false,
    this.likeCount = 0,
    this.parentId,
    List<Comment>? replies,
  }) : replies = replies ?? [];


  factory Comment.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Comment(
      id: documentId,
      postId: data['postId'] ?? '',
      author: data['author'] ?? 'Ẩn danh',
      content: data['content'] ?? '',
      date: data['date'] ?? '',
      isLiked: data['isLiked'] ?? false,
      likeCount: data['likeCount'] ?? 0,
      parentId: data['parentId'],
      replies: [], // Danh sách replies sẽ được Provider gom nhóm sau khi kéo từ Firestore về
    );
  }

  Comment copyWith({
    String? id,
    String? postId,
    String? author,
    String? content,
    String? date,
    bool? isLiked,
    int? likeCount,
    String? parentId,
    List<Comment>? replies,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      author: author ?? this.author,
      content: content ?? this.content,
      date: date ?? this.date,
      isLiked: isLiked ?? this.isLiked,
      likeCount: likeCount ?? this.likeCount,
      parentId: parentId ?? this.parentId,
      replies: replies ?? this.replies,
    );
  }
}