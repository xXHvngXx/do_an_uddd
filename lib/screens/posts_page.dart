import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/posts_data.dart'; 
import '../data/sample_comments.dart';
import '../provider/post_provider.dart';
import 'posts_detail_page.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  // Đổi sang Set để lưu danh sách các category được chọn
  final Set<String> _selectedCategories = {'Tất cả'};
  String _searchQuery = '';

  final List<String> _categories = [
    'Tất cả',
    'Kinh nghiệm',
    'Ẩm thực',
    'Địa điểm',
  ];

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    // Cập nhật logic lọc theo đa danh mục
    final filteredPosts = postProvider.posts.where((post) {
      // - Nếu chưa chọn gì (isEmpty)
      // - Hoặc chọn "Tất cả"
      // - Hoặc bài viết chứa ÍT NHẤT 1 danh mục nằm trong _selectedCategories
      final matchesCategory = _selectedCategories.isEmpty ||
          _selectedCategories.contains('Tất cả') ||
          (post.categories).any(
            (cat) => _selectedCategories.contains(cat),
          );

      // Logic tìm kiếm (Search Query):
      final query = _searchQuery.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          (post.title).toLowerCase().contains(query) ||
          (post.summary).toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: false,
            elevation: 0,
            scrolledUnderElevation: 1.0,
            backgroundColor: Colors.white,
            expandedHeight: 70.0,
            flexibleSpace: const FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                'Khám Phá Bài Viết',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF334155),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm bài viết, chủ đề...',
                      hintStyle: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: Color(0xFF0F766E),
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear_rounded,
                                size: 18,
                                color: Color(0xFF94A3B8),
                              ),
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF0F766E),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),

                // 📍 3. Category Filter Chips (Cho phép Multi-select)
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = _selectedCategories.contains(cat);

                      return FilterChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (cat == 'Tất cả') {
                              _selectedCategories.clear();
                              _selectedCategories.add('Tất cả');
                            } else {
                              _selectedCategories.remove('Tất cả');
                              if (selected) {
                                _selectedCategories.add(cat);
                              } else {
                                _selectedCategories.remove(cat);
                              }
                              // Nếu bỏ chọn hết thì mặc định quay về 'Tất cả'
                              if (_selectedCategories.isEmpty) {
                                _selectedCategories.add('Tất cả');
                              }
                            }
                          });
                        },
                        selectedColor: const Color(0xFF0F766E),
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF475569),
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected
                                ? const Color(0xFF0F766E)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        showCheckmark: false,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Featured Section
                if (_searchQuery.isEmpty &&
                    _selectedCategories.contains('Tất cả')) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Nổi Bật Trong Tuần 🔥',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: postProvider.posts.length > 3
                          ? 3
                          : postProvider.posts.length,
                      itemBuilder: (context, index) {
                        final post = postProvider.posts[index];
                        return _buildFeaturedCard(context, post);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Mới Cập Nhật',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),

          // Danh sách bài viết chính
          filteredPosts.isEmpty
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Không tìm thấy bài viết nào',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final post = filteredPosts[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFF1F5F9)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0F172A)
                                  .withValues(alpha: 0.04),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PostDetailPage(postId: post.id),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 18,
                                        backgroundColor: const Color(
                                          0xFFCCFBF1,
                                        ),
                                        child: Text(
                                          (post.author.isNotEmpty)
                                              ? post.author[0]
                                              : 'A',
                                          style: const TextStyle(
                                            color: Color(0xFF0F766E),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              post.author,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: Color(0xFF0F172A),
                                              ),
                                            ),
                                            Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: [
                                                Text(
                                                  post.date,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Color(0xFF94A3B8),
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                const Text(
                                                  '•',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Color(0xFF94A3B8),
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                const Icon(
                                                  Icons.access_time_rounded,
                                                  size: 11,
                                                  color: Color(0xFF94A3B8),
                                                ),
                                                const SizedBox(width: 2),
                                                const Text(
                                                  '5 phút đọc',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Color(0xFF94A3B8),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          post.isBookMarked
                                              ? Icons.bookmark_rounded
                                              : Icons.bookmark_border_rounded,
                                          color: post.isBookMarked
                                              ? const Color(0xFF0F766E)
                                              : const Color(0xFF94A3B8),
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          postProvider.toggleBookmark(post.id);
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  Text(
                                    post.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F172A),
                                      height: 1.35,
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  Text(
                                    post.summary,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF64748B),
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // 📍 4. Hiển thị danh sách các Tags dạng Wrap
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Wrap(
                                          spacing: 6,
                                          runSpacing: 4,
                                          children: (post
                                                  .categories) //Nếu bài viết không có danh mục thì bỏ hashtag
                                              .map((cat) {
                                            return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                  0xFFCCFBF1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  6,
                                                ),
                                              ),
                                              child: Text(
                                                '#$cat',
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Color(0xFF0F766E),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            onTap: () {
                                              postProvider.toggleLike(post.id);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 4,
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    post.isLiked
                                                        ? Icons.favorite_rounded
                                                        : Icons
                                                            .favorite_border_rounded,
                                                    size: 16,
                                                    color: post.isLiked
                                                        ? Colors.redAccent
                                                        : const Color(
                                                            0xFF64748B,
                                                          ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${post.likeCount}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: post.isLiked
                                                          ? Colors.redAccent
                                                          : const Color(
                                                              0xFF64748B,
                                                            ),
                                                      fontWeight: post.isLiked
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          const Icon(
                                            Icons.share_outlined,
                                            size: 16,
                                            color: Color(0xFF64748B),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }, childCount: filteredPosts.length),
                  ),
                ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  String _getImageUrl(String postId) {
    final Map<String, String> imageMap = {
      '1': 'https://images.unsplash.com/photo-1528127269322-539801943592',
      '2': 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb',
      '3': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1',
    };
    return imageMap[postId] ??
        'https://images.unsplash.com/photo-1528127269322-539801943592';
  }

  Widget _buildFeaturedCard(BuildContext context, dynamic post) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(_getImageUrl(post.id)),
          onError: (error, stackTrace) {},
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F766E).withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.2),
              Colors.black.withValues(alpha: 0.85),
            ],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetailPage(postId: post.id),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Trending',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 20,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            post.author,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '•  ${post.date}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}