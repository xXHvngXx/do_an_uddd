import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/comment_provider.dart';
import '../models/comment.dart';

class CommentsBottomSheet extends StatefulWidget {
  final String postId;

  const CommentsBottomSheet({super.key, required this.postId});

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Comment? _replyingTo;

  void _submitComment(CommentProvider provider) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    provider.addComment(
      postId: widget.postId,
      content: text,
      parentId: _replyingTo?.id,
    );

    _controller.clear();
    _focusNode.unfocus();
    setState(() {
      _replyingTo = null;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentProvider = Provider.of<CommentProvider>(context);
    final postComments = commentProvider.getCommentsByPostId(widget.postId);
    final totalCount = commentProvider.getCommentCount(widget.postId);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Thanh Kéo Header
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bình luận ($totalCount)',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                IconButton(
                  icon:
                      const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // Danh Sách Bình Luận
          Expanded(
            child: postComments.isEmpty
                ? const Center(
                    child: Text(
                      'Chưa có bình luận nào. Hãy là người đầu tiên!',
                      style: TextStyle(color: Color(0xFF94A3B8)),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: postComments.length,
                    itemBuilder: (context, index) {
                      return _buildCommentTile(
                          postComments[index], commentProvider);
                    },
                  ),
          ),

          // Khung thông báo đang Trả lời ai
          if (_replyingTo != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFF1F5F9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Đang trả lời ${_replyingTo!.author}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F766E),
                    ),
                  ),
                  InkWell(
                    onTap: () => setState(() => _replyingTo = null),
                    child: const Icon(Icons.close,
                        size: 16, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),

          // Thanh Gõ Bình Luận (Cố định ở đáy)
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 12,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: _replyingTo == null
                          ? 'Viết bình luận...'
                          : 'Trả lời ${_replyingTo!.author}...',
                      hintStyle: const TextStyle(
                          fontSize: 13, color: Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Color(0xFF0F766E)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon:
                      const Icon(Icons.send_rounded, color: Color(0xFF0F766E)),
                  onPressed: () => _submitComment(commentProvider),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị từng dòng Comment & Reply
  Widget _buildCommentTile(Comment comment, CommentProvider provider,
      {bool isReply = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16, left: isReply ? 32 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: isReply ? 12 : 16,
                backgroundColor: const Color(0xFFCCFBF1),
                child: Text(
                  comment.author.isNotEmpty ? comment.author[0] : 'A',
                  style: TextStyle(
                    fontSize: isReply ? 10 : 12,
                    color: const Color(0xFF0F766E),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment.author,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            comment.content,
                            style: const TextStyle(
                                fontSize: 13, color: Color(0xFF334155)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 4),
                      child: Row(
                        children: [
                          Text(
                            comment.date,
                            style: const TextStyle(
                                fontSize: 11, color: Color(0xFF94A3B8)),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _replyingTo = comment;
                              });
                              _focusNode.requestFocus();
                            },
                            child: const Text(
                              'Trả lời',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Nút Thả Tim Comment
              InkWell(
                onTap: () => provider.toggleLikeComment(comment.id),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Icon(
                        comment.isLiked
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 15,
                        color: comment.isLiked
                            ? Colors.redAccent
                            : const Color(0xFF94A3B8),
                      ),
                      if (comment.likeCount > 0) ...[
                        const SizedBox(width: 2),
                        Text(
                          '${comment.likeCount}',
                          style: TextStyle(
                            fontSize: 11,
                            color: comment.isLiked
                                ? Colors.redAccent
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Render danh sách Reply
          if (comment.replies.isNotEmpty)
            ...comment.replies.map(
                (reply) => _buildCommentTile(reply, provider, isReply: true)),
        ],
      ),
    );
  }
}
