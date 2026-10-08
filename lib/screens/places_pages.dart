import 'package:flutter/material.dart';
import '../data/places_data.dart';

String removeVietnameseDiacritics(String str) {
  var withDiacritics =
      'àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ'
      'ÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐ';
  var withoutDiacritics =
      'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyd'
      'AAAAAAAAAAAAAAAAAEEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOOOUUUUUUUUUUUYYYYYD';

  for (int i = 0; i < withDiacritics.length; i++) {
    str = str.replaceAll(withDiacritics[i], withoutDiacritics[i]);
  }
  return str.toLowerCase(); // Chuyển toàn bộ về chữ thường
}

class PlaceCard extends StatelessWidget {
  final Place place; // Đối tượng địa danh truyền vào
  final Function(Place) onToggleFavorite; // Callback xử lý khi ấn nút tim

  const PlaceCard({
    super.key,
    required this.place,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Bấm vào thẻ để chuyển sang màn hình Chi tiết địa danh
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceDetailPage(
              place: place,
              onToggleFavorite: onToggleFavorite,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF), // Màu nền thẻ trắng
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)), // Bo viền thẻ
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Phần 1: Khối ảnh địa danh hiển thị từ Link Network ---
            Container(
              height: 180,
              width: double.infinity,
              color: const Color(0xFFE2E8F0),
              child: Stack(
                children: [
                  // 🖼️ Hiển thị ảnh thực tế với BoxFit.cover
                  Positioned.fill(
                    child: Image.network(
                      place.imageUrl,
                      fit: BoxFit.cover,
                      // Xử lý hiển thị icon lỗi nếu mạng không tải được ảnh
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                        child: Icon(Icons.broken_image,
                            color: Colors.grey, size: 40),
                      ),
                    ),
                  ),
                  // Nút hình trái tim ở góc trên phải để Lưu/Xóa yêu thích
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () => onToggleFavorite(place),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          place.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: place.isFavorite
                              ? Colors.red
                              : const Color(0xFF0F172A),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- Phần 2: Nội dung chữ bên dưới thẻ ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên địa danh (In đậm)
                  Text(
                    place.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Tỉnh / Thành phố
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Color(0xFF475569),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        place.location,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Tag danh mục (Biển/Núi) & Điểm đánh giá
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 8,
                    children: [
                      // Tag loại hình
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCCFBF1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          place.category,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF0F766E),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Điểm rating và số đánh giá
                      Text(
                        '${place.rating}/5 · ${place.reviewCount} đánh giá',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF475569),
                        ),
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
  }
}

// -----------------------------------------------------------------------------
// 4. TRANG KHÁM PHÁ (ExplorePage)
// -----------------------------------------------------------------------------
/// Màn hình Khám phá chính chứa: Ô Tìm kiếm gần đúng, Nút Lọc danh mục, Danh sách địa danh
class ExplorePage extends StatefulWidget {
  final Function(Place) onToggleFavorite;

  const ExplorePage({super.key, required this.onToggleFavorite});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  int _selectedCategoryIndex = 0; // Danh mục lọc đang chọn (0: Tất cả)
  String _searchQuery = ''; // Từ khóa tìm kiếm hiện tại
  final TextEditingController _searchController =
      TextEditingController(); // Controller quản lý Input
  final FocusNode _searchFocusNode =
      FocusNode(); // Quản lý con trỏ Focus ô nhập

  List<Place> _suggestions = []; // Danh sách gợi ý xổ xuống khi gõ
  bool _showSuggestions = false; // Bật/Tắt hiển thị bảng gợi ý

  final List<String> _categories = ['Tất cả', 'Biển', 'Núi', 'Văn hóa'];

  @override
  void initState() {
    super.initState();
    // Tự động ẩn bảng gợi ý khi người dùng bỏ con trỏ khỏi ô tìm kiếm
    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus) {
        setState(() {
          _showSuggestions = false;
        });
      }
    });
  }

  /// Hàm xử lý logic lọc địa danh gợi ý khi người dùng gõ vào Ô Tìm kiếm
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });

    // Nếu ô nhập rỗng -> Ẩn bảng gợi ý
    if (query.trim().isEmpty) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    // Chuẩn hóa từ khóa tìm kiếm (Loại bỏ dấu tiếng Việt)
    final normalizedQuery = removeVietnameseDiacritics(query.trim());

    // Lọc các địa danh khớp tên hoặc địa điểm với từ khóa gần đúng
    final results = samplePlaces.where((place) {
      final nameNormalized = removeVietnameseDiacritics(place.name);
      final locationNormalized = removeVietnameseDiacritics(place.location);
      return nameNormalized.contains(normalizedQuery) ||
          locationNormalized.contains(normalizedQuery);
    }).toList();

    // Cập nhật danh sách gợi ý và hiển thị lên
    setState(() {
      _suggestions = results;
      _showSuggestions = results.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Chuẩn hóa câu tìm kiếm chính
    final normalizedSearchQuery =
        removeVietnameseDiacritics(_searchQuery.trim());

    // Lọc danh sách địa danh hiển thị chính bên dưới theo từ khóa VÀ danh mục được chọn
    final filteredPlaces = samplePlaces.where((place) {
      final nameNormalized = removeVietnameseDiacritics(place.name);
      final locationNormalized = removeVietnameseDiacritics(place.location);

      final matchesSearch = normalizedSearchQuery.isEmpty ||
          nameNormalized.contains(normalizedSearchQuery) ||
          locationNormalized.contains(normalizedSearchQuery);

      final matchesCategory = _selectedCategoryIndex == 0 ||
          place.category == _categories[_selectedCategoryIndex];

      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/map');
        },
        backgroundColor: const Color(0xFF0F766E),
        icon: const Icon(Icons.map, color: Colors.white),
        label: const Text(
          'Bản đồ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Việt Đi',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A), 
                  ),
                ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: const Color(0xFF0F766E), width: 1.5),
                ),
                child: const Icon(
                  Icons.explore_outlined,
                  color: Color(0xFF0F766E),
                  size: 20,
                ),
              )
            ],
          ),
          const SizedBox(height: 24),

          // Tiêu đề & Phụ đề trang chủ
          const Text(
            'Việt Nam, đi và khám phá',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tìm một điểm đến cho hành trình tiếp theo.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 20),

          // --- Khối Ô Tìm Kiếm & Bảng Gợi Ý Xổ Xuống ---
          Column(
            children: [
              // TextField Ô Nhập Tìm Kiếm
              TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Tìm tên địa danh (vd: ha long, da lat)',
                  hintStyle: const TextStyle(
                    color: Color(0xFF475569),
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF475569),
                    size: 22,
                  ),
                  // Nút Xóa nhanh từ khóa (dấu X)
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: const Color(0xFFFFFFFF),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: Color(0xFF0F766E), width: 1.5),
                  ),
                ),
              ),

              // BẢNG GỢI Ý XỔ XUỐNG KHI GÕ
              if (_showSuggestions)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _suggestions.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    itemBuilder: (context, index) {
                      final item = _suggestions[index];
                      return Material(
                          color: Colors.transparent,
                          child: ListTile(
                            dense: true,
                            leading: const Icon(Icons.place_outlined,
                                color: Color(0xFF0F766E), size: 20),
                            title: Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            subtitle: Text(
                              item.location,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF475569),
                              ),
                            ),
                            trailing: const Icon(Icons.north_west,
                                size: 16, color: Color(0xFF475569)),
                            onTap: () {
                              // Tự điền tên địa danh chọn vào ô nhập & Đóng gợi ý
                              _searchController.text = item.name;
                              _onSearchChanged(item.name);
                              _searchFocusNode.unfocus();

                              // Chuyển thẳng đến trang Chi tiết địa danh được chọn
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlaceDetailPage(
                                    place: item,
                                    onToggleFavorite: widget.onToggleFavorite,
                                  ),
                                ),
                              );
                            },
                          ));
                    },
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // --- Khối Danh sách Các Nút Lọc Danh Mục (Nằm ngang) ---
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedCategoryIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index; // Chọn danh mục lọc
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFCCFBF1)
                          : const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF0F766E).withValues(alpha: 0.3)
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _categories[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? const Color(0xFF0F766E)
                              : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // --- Khối Tiêu đề Danh sách & Số lượng kết quả ---
          const Text(
            'Khám phá địa danh',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${filteredPlaces.length} địa danh',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 16),

          // --- Khối Danh Sách Địa Danh (ListView) ---
          filteredPlaces.isEmpty
              ? const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(
                    child: Text(
                      'Không tìm thấy địa danh phù hợp',
                      style: TextStyle(color: Color(0xFF475569)),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(), // Cuộn theo SingleChildScrollView cha
                  itemCount: filteredPlaces.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return PlaceCard(
                      place: filteredPlaces[index],
                      onToggleFavorite: widget.onToggleFavorite,
                    );
                  },
                ),
        ],
      ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 5. TRANG DANH SÁCH YÊU THÍCH (FavoritesPage)
// -----------------------------------------------------------------------------
/// Màn hình hiển thị toàn bộ những địa danh đã được thả tim (Lưu lại)
class FavoritesPage extends StatelessWidget {
  final Function(Place) onToggleFavorite;

  const FavoritesPage({super.key, required this.onToggleFavorite});

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách chỉ lấy những địa danh có isFavorite == true
    final favoritePlaces =
        samplePlaces.where((place) => place.isFavorite).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Địa danh yêu thích',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${favoritePlaces.length} địa danh đã lưu',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 20),

          // Kiểm tra nếu chưa thả tim địa danh nào
          favoritePlaces.isEmpty
              ? const Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Center(
                    child: Text(
                      'Chưa có địa danh yêu thích nào được lưu.',
                      style: TextStyle(color: Color(0xFF475569), fontSize: 14),
                    ),
                  ),
                )
              // Hiển thị danh sách địa danh đã thả tim (Dùng chung PlaceCard)
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: favoritePlaces.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return PlaceCard(
                      place: favoritePlaces[index],
                      onToggleFavorite: onToggleFavorite,
                    );
                  },
                ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 6. TRANG CHI TIẾT ĐỊA DANH (PlaceDetailPage - Bổ sung ảnh lớn)
// -----------------------------------------------------------------------------
/// Màn hình xem thông tin chi tiết địa danh khi bấm chọn từ danh sách
class PlaceDetailPage extends StatefulWidget {
  final Place place; // Địa danh cụ thể cần xem chi tiết
  final Function(Place) onToggleFavorite; // Callback xử lý yêu thích

  const PlaceDetailPage({
    super.key,
    required this.place,
    required this.onToggleFavorite,
  });

  @override
  State<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  @override
  Widget build(BuildContext context) {
    final place = widget.place;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // --- Header trên: Nút Back, Tiêu đề trang, Nút Yêu thích ---
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nút Quay lại
                  IconButton(
                    icon:
                        const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Chi tiết địa danh',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  // Nút thả tim ở Header
                  IconButton(
                    icon: Icon(
                      place.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: place.isFavorite
                          ? Colors.red
                          : const Color(0xFF0F172A),
                    ),
                    onPressed: () {
                      setState(() {
                        widget.onToggleFavorite(place);
                      });
                    },
                  ),
                ],
              ),
            ),

            // --- Khối nội dung thông tin chi tiết ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🖼️ Banner Hình ảnh thực tế lớn
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        place.imageUrl,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 220,
                          color: const Color(0xFFE2E8F0),
                          child: const Center(
                            child: Icon(Icons.broken_image,
                                color: Colors.grey, size: 48),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tên địa danh lớn
                    Text(
                      place.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Địa điểm
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 18,
                          color: Color(0xFF475569),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          place.location,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Tag Danh mục & Đánh giá
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runSpacing: 8,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFCCFBF1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            place.category,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF0F766E),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${place.rating} (${place.reviewCount} đánh giá)',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Đoạn văn bản Giới thiệu
                    const Text(
                      'Giới thiệu',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      place.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF475569),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
