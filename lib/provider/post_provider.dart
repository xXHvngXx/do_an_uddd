import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/posts_data.dart';

class PostProvider extends ChangeNotifier {
  List<Post> _posts = [];
  bool _isLoading = true;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;

  // Khi Provider được khởi tạo, tự động gọi dữ liệu từ Firebase
  PostProvider() {
    fetchPosts();
  }

  // Hàm kéo dữ liệu từ Firebase về
  Future<void> fetchPosts() async {
    _isLoading = true;
    
    try {
      final snapshot = await FirebaseFirestore.instance.collection('posts').get();
      
      _posts = snapshot.docs.map((doc) {
        return Post.fromFirestore(doc.data(), doc.id);
      }).toList();

    } catch (error) {
      debugPrint('Lỗi tải bài viết từ Firebase: $error');
    } finally {
      _isLoading = false;
      notifyListeners(); // Báo cho PostsPage vẽ lại giao diện khi đã có dữ liệu
    }
  }

  // Hàm chuyển đổi trạng thái Thích (Like)
  void toggleLike(String postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      _posts[index].isLiked = !_posts[index].isLiked;
      _posts[index].likeCount += _posts[index].isLiked ? 1 : -1;
      notifyListeners();

      try {
        await FirebaseFirestore.instance.collection('posts').doc(postId).update({
          'isLiked': _posts[index].isLiked,
          'likeCount': _posts[index].likeCount,
        });
      } catch (error) {
        debugPrint('Lỗi cập nhật Like lên Firebase: $error');
      }
    }
  }

  // Hàm chuyển đổi trạng thái Lưu (Bookmark)
  void toggleBookmark(String postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      _posts[index].isBookMarked = !_posts[index].isBookMarked;
      notifyListeners();

      try {
        await FirebaseFirestore.instance.collection('posts').doc(postId).update({
          'isBookMarked': _posts[index].isBookMarked,
        });
      } catch (error) {
        debugPrint('Lỗi cập nhật Bookmark lên Firebase: $error');
      }
    }
  }
}