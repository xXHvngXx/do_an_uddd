import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/comments_bottom_sheet.dart';
import '../provider/comment_provider.dart';

import '../provider/post_provider.dart';

class PostDetailPage extends StatelessWidget {
  final String postId;

  const PostDetailPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    final post = postProvider.posts.firstWhere((p) => p.id == postId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF0F172A),
        actions: [
          IconButton(
            icon: Icon(
              post.isBookMarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: post.isBookMarked
                  ? const Color(0xFF0F766E)
                  : const Color(0xFF0F172A),
            ),
            onPressed: () {
              postProvider.toggleBookmark(post.id);
            },
          ),
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị Category động từ bài viết
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: (post.categories.isNotEmpty
                      ? post.categories
                      : ['EXPERIENCE'])
                  .map((category) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCCFBF1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    category.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F766E),
                      letterSpacing: 1,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFF0F766E),
                  child: Text(
                    post.author.isNotEmpty ? post.author[0] : 'A',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.author,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Cập nhật ngày ${post.date}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            const SizedBox(height: 20),
            // Tóm tắt nội dung
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: const Border(
                  left: BorderSide(color: Color(0xFF0F766E), width: 4),
                ),
              ),
              child: Text(
                post.summary,
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF475569),
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              post.content,
              style: const TextStyle(
                fontSize: 15,
                height: 1.8,
                color: Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Thanh thả tim & số lượng thích
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    post.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: const Color(0xFFE11D48),
                  ),
                  onPressed: () {
                    postProvider.toggleLike(post.id);
                  },
                ),
                Text(
                  '${post.likeCount} Yêu thích',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled:
                      true, // Giúp nâng khung khi bàn phím hiện lên
                  backgroundColor: Colors.transparent,
                  builder: (context) => CommentsBottomSheet(postId: post.id),
                );
              },
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
              label: Consumer<CommentProvider>(
                builder: (context, commentProvider, child) {
                  final count = commentProvider.getCommentCount(post.id);
                  return Text('Bình luận ${count > 0 ? '($count)' : ''}');
                },
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F766E),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
