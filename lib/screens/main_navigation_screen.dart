import 'package:flutter/material.dart';
import '../data/places_data.dart';
import 'places_pages.dart';
import 'posts_page.dart';
import 'profile_screen.dart';

/// Tab chỉ đổi nội dung; trang chi tiết dùng Navigator.push ở màn hình tương ứng.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _index = 0;

  void _toggleFavorite(Place place) => setState(() {
        place.isFavorite = !place.isFavorite;
      });

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: IndexedStack(index: _index, children: [
            ExplorePage(onToggleFavorite: _toggleFavorite),
            FavoritesPage(onToggleFavorite: _toggleFavorite),
            const PostsPage(),
            const ProfileScreen(),
          ]),
        ),
        bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFCCFBF1),
          selectedIndex: _index,
          onDestinationSelected: (value) => setState(() => _index = value),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.explore_outlined),
                selectedIcon: Icon(Icons.explore),
                label: 'Khám phá'),
            NavigationDestination(
                icon: Icon(Icons.favorite_border),
                selectedIcon: Icon(Icons.favorite),
                label: 'Yêu thích'),
            NavigationDestination(
                icon: Icon(Icons.article_outlined),
                selectedIcon: Icon(Icons.article),
                label: 'Bài viết'),
            NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Cá nhân'),
          ],
        ),
      );
}
