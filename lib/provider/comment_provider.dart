import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comment.dart';

class CommentProvider extends ChangeNotifier {
  List<Comment> _comments = [];
  bool _isLoading = true;

  // 📍 Tạm biệt Nguyễn Văn X, để tên thật cho xịn xò nhé!
  String _currentAuthorName = 'Phạm Minh Hưng';
  String get currentAuthorName => _currentAuthorName;

  List<Comment> get comments => _comments;
  bool get isLoading => _isLoading;

  CommentProvider() {
    fetchComments();
  }

  // 📍 Rút dữ liệu từ Firebase và tự động lồng ghép Reply vào Comment cha
  Future<void> fetchComments() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance.collection('comments').get();
      
      // 1. Chuyển đổi dữ liệu thô thành danh sách phẳng
      List<Comment> allComments = snapshot.docs.map((doc) {
        return Comment.fromFirestore(doc.data(), doc.id);
      }).toList();

      // 2. Phân loại: đâu là cha (gốc), đâu là con (reply)
      List<Comment> parentComments = allComments.where((c) => c.parentId == null).toList();
      List<Comment> childComments = allComments.where((c) => c.parentId != null).toList();

      // 3. Lắp ráp: Nhét comment con vào mảng replies của comment cha
      for (var parent in parentComments) {
        parent.replies = childComments.where((child) => child.parentId == parent.id).toList();
      }

      // 4. Lưu lại danh sách chứa các comment gốc để giao diện hiển thị
      _comments = parentComments;

    } catch (error) {
      debugPrint('Lỗi tải bình luận từ Firebase: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 📍 Cập nhật tên tác giả trên UI và đồng bộ Batch Update lên Firebase
  void updateGlobalAuthorName(String newName) async {
    if (_currentAuthorName == newName) return;

    final oldName = _currentAuthorName;
    _currentAuthorName = newName;

    // 1. Cập nhật UI ngay lập tức
    void updateRecursive(List<Comment> commentList) {
      for (int i = 0; i < commentList.length; i++) {
        var comment = commentList[i];
        if (comment.author == oldName) {
          commentList[i] = comment.copyWith(author: newName);
        }
        if (comment.replies != null && comment.replies!.isNotEmpty) {
          updateRecursive(comment.replies!);
        }
      }
    }
    updateRecursive(_comments);
    notifyListeners();

    // 2. Cập nhật đồng loạt trên Firebase
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('comments')
          .where('author', isEqualTo: oldName)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        final batch = FirebaseFirestore.instance.batch(); // Dùng Batch để tiết kiệm số lần ghi
        for (var doc in snapshot.docs) {
          batch.update(doc.reference, {'author': newName});
        }
        await batch.commit();
      }
    } catch (error) {
      debugPrint('Lỗi đổi tên trên Firebase: $error');
    }
  }

  List<Comment> getCommentsByPostId(String postId) {
    return _comments.where((c) => c.postId == postId).toList();
  }

  int getCommentCount(String postId) {
    int total = 0;
    final postComments = _comments.where((c) => c.postId == postId);
    for (var comment in postComments) {
      total += 1 + (comment.replies?.length ?? 0);
    }
    return total;
  }

  // 📍 Thêm Bình luận mới - Cập nhật Optimistic
  void addComment({
    required String postId,
    required String content,
    String? parentId,
  }) async {
    // Tạo trước 1 Document Reference để lấy ID rỗng
    final docRef = FirebaseFirestore.instance.collection('comments').doc();
    final newId = docRef.id;

    final newComment = Comment(
      id: newId,
      postId: postId,
      author: _currentAuthorName, 
      content: content,
      date: 'Vừa xong',
      parentId: parentId,
      replies: [], // Khởi tạo mảng rỗng để không bị lỗi null
    );

    // 1. Nhét vào danh sách hiển thị liền cho người dùng thấy mượt
    if (parentId == null) {
      _comments.insert(0, newComment);
    } else {
      final parentComment = _findCommentById(_comments, parentId);
      if (parentComment != null) {
        parentComment.replies ??= [];
        parentComment.replies!.add(newComment);
      }
    }
    notifyListeners();

    // 2. Gửi dữ liệu thật lên Firebase ở dưới nền
    try {
      await docRef.set({
        'postId': postId,
        'parentId': parentId,
        'author': _currentAuthorName,
        'content': content,
        'date': 'Vừa xong', 
        'likeCount': 0,
        'isLiked': false,
      });
    } catch (error) {
      debugPrint('Lỗi thêm bình luận: $error');
    }
  }

  // 📍 Thả tim / Bỏ tim và đồng bộ
  void toggleLikeComment(String commentId) async {
    final targetComment = _findCommentById(_comments, commentId);
    if (targetComment != null) {
      // Cập nhật UI
      targetComment.isLiked = !targetComment.isLiked;
      targetComment.likeCount += targetComment.isLiked ? 1 : -1;
      notifyListeners();

      // Cập nhật Firebase
      try {
        await FirebaseFirestore.instance.collection('comments').doc(commentId).update({
          'isLiked': targetComment.isLiked,
          'likeCount': targetComment.likeCount,
        });
      } catch (error) {
        debugPrint('Lỗi thả tim bình luận: $error');
      }
    }
  }

  Comment? _findCommentById(List<Comment> list, String id) {
    for (var comment in list) {
      if (comment.id == id) return comment;
      if (comment.replies != null && comment.replies!.isNotEmpty) {
        final found = _findCommentById(comment.replies!, id);
        if (found != null) return found;
      }
    }
    return null;
  }
}