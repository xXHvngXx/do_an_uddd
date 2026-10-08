// lib/places_data.dart

class Place {
  final String id;
  final String name;
  final String location;
  final String category;
  final double rating;
  final int reviewCount;
  final String description;
  final String imageUrl; // ➕ 1. Thêm trường imageUrl
  bool isFavorite;

  Place({
    required this.id,
    required this.name,
    required this.location,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.imageUrl, // ➕ 2. Thêm vào constructor
    this.isFavorite = false,
  });
}

// ➕ 3. Cập nhật danh sách dữ liệu kèm link ảnh
final List<Place> samplePlaces = [
  Place(
    id: '1',
    name: 'Vịnh Hạ Long',
    location: 'Quảng Ninh',
    category: 'Biển',
    rating: 4.8,
    reviewCount: 128,
    description: 'Vịnh Hạ Long là một trong những kỳ quan...',
    imageUrl:
        'https://images.unsplash.com/photo-1528127269322-539801943592?w=600',
  ),
  Place(
    id: '2',
    name: 'Thành phố Đà Lạt',
    location: 'Lâm Đồng',
    category: 'Núi',
    rating: 4.9,
    reviewCount: 256,
    description: 'Đà Lạt thu hút du khách bởi khí hậu mát mẻ...',
    imageUrl:
        'https://vstatic.vietnam.vn/vietnam/resource/IMAGE/2025/1/19/ee6ebc59825f4871997c8782281b485a',
  ),
  Place(
    id: '3',
    name: 'Phố cổ Hội An',
    location: 'Quảng Nam',
    category: 'Văn hóa',
    rating: 4.7,
    reviewCount: 190,
    description: 'Phố cổ Hội An mang vẻ đẹp cổ kính...',
    imageUrl:
        'https://tinviettravel.com.vn/uploads/cam-nang-du-lich/2025_07/hoi-an-6.jpg',
  ),
  Place(
    id: '4',
    name: 'Đảo Phú Quốc',
    location: 'Kiên Giang',
    category: 'Biển',
    rating: 4.9,
    reviewCount: 950,
    description:
        'Đảo Ngọc Phú Quốc nổi tiếng với các bãi biển cát trắng trải dài, hoàng hôn lãng mạn và hệ sinh thái biển phong phú.',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSeUZfEkt572Cm3H3-AF9XsMxBK2X6Y7y63waJnp2_9ibYmoImu96SY1CQY&s=10',
  ),
  Place(
    id: '5',
    name: 'Bãi biển Nha Trang',
    location: 'Khánh Hòa',
    category: 'Biển',
    rating: 4.7,
    reviewCount: 820,
    description:
        'Nha Trang sở hữu một trong những vịnh biển đẹp nhất thế giới với dải cát vàng mịn, làn nước trong xanh và nhiều hoạt động thể thao dưới nước.',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRzwcoNbK7wpzccy4LoqcKboctk1P68JEGE1zjhXbKf3A&s=10',
  ),
  Place(
    id: '6',
    name: 'Mũi Né',
    location: 'Bình Thuận',
    category: 'Biển',
    rating: 4.6,
    reviewCount: 640,
    description:
        'Mũi Né hấp dẫn du khách bởi những đồi cát bay mênh mông, bãi biển lung linh nắng ấm và làng chài bình yên.',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYIE5V_LaBdhrIIG825tNog_gItxsxEemJkI3UPFzUCw&s=10',
  ),
  Place(
    id: '7',
    name: 'Quần đảo Côn Đảo',
    location: 'Bà Rịa - Vũng Tàu',
    category: 'Biển',
    rating: 4.9,
    reviewCount: 430,
    description:
        'Côn Đảo mang vẻ đẹp hoang sơ, huyền bí với vô số bãi tắm tuyệt đẹp, rặng san hô tự nhiên và di tích lịch sử linh thiêng.',
    imageUrl:
        'https://cdn2.tuoitre.vn/nld/291774122806476800/2026/3/2/img6889-1772430465727648357996.jpeg',
  ),
  Place(
    id: '11',
    name: 'Thị trấn Sa Pa',
    location: 'Lào Cai',
    category: 'Núi',
    rating: 4.8,
    reviewCount: 1780,
    description:
        'Sa Pa nằm dưới chân dãy Hoàng Liên Sơn, nổi tiếng với ruộng bậc thang hùng vĩ, đỉnh Fansipan huyền thoại và văn hóa dân tộc độc đáo.',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQCf4ks68jkVAv54guwqw0sRjHpm5a8Ok0ESMMgF-FD6A&s=10',
  ),
  Place(
    id: '8',
    name: 'Đỉnh Mẫu Sơn',
    location: 'Lạng Sơn',
    category: 'Núi',
    rating: 4.5,
    reviewCount: 310,
    description:
        'Vùng núi cao Mẫu Sơn có khí hậu thuần lạnh quanh năm, không gian tĩnh lặng và là điểm săn tuyết rơi lý tưởng vào mùa đông.',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTkW1BN3oKkNVgcTJpBGffGqlxzsaUadcyRnFcf4aKP6Q&s=10',
  ),
  Place(
    id: '9',
    name: 'Hà Giang - Cao nguyên đá',
    location: 'Hà Giang',
    category: 'Núi',
    rating: 4.9,
    reviewCount: 1420,
    description:
        'Hà Giang gây ấn tượng mạnh với đèo Mã Pí Lèng hiểm trở, dòng sông Nho Quế xanh ngọc và cao nguyên đá Đồng Văn hùng vĩ.',
    imageUrl:
        'https://lh7-rt.googleusercontent.com/docsz/AD_4nXdMREV9njd2l9p6EVdpp5XbZ7TpYB5Rylp9oig5W4Y4V-nHRiCsxDTHWAjnklmd9Wg1NoviDH32a2rawfuikDUBZhbo1CZ7cW-JPN9nHySopR0DATcu6kkpem-2Y3sYKy1mJhTmtNGhxaS_tC37T_OPEl4?key=0o_qhYvjBhYLDAMpKkS7TA',
  ),
  Place(
    id: '10',
    name: 'Mộc Châu',
    location: 'Sơn La',
    category: 'Núi',
    rating: 4.7,
    reviewCount: 890,
    description:
        'Cao nguyên Mộc Châu nổi tiếng với những đồi chè xanh mướt trải dài ngút ngàn, rừng hoa mận trắng xóa và không khí trong lành.',
    imageUrl:
        'https://cloudcdnvod.tek4tv.vn/2025/10/1/11/444817194_146567886cao-nguyen-moc-chau.webp',
  ),
  Place(
    id: '12',
    name: 'Cố đô Huế',
    location: 'Thừa Thiên Huế',
    category: 'Văn hóa',
    rating: 4.7,
    reviewCount: 1350,
    description:
        'Cố đô Huế lưu giữ quần thể di tích Đại Nội cổ kính, các lăng tăm triều Nguyễn cùng nét văn hóa sông Hương trầm mặc.',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxze2EixMQIZMP7e_NtbrTN3chtP61297G5d5oRMQepQ&s=10',
  ),
  Place(
    id: '13',
    name: 'Quần thể Tràng An',
    location: 'Ninh Bình',
    category: 'Văn hóa',
    rating: 4.9,
    reviewCount: 1620,
    description:
        'Tràng An là di sản thế giới kép kết hợp giữa vẻ đẹp thiên nhiên non nước hữu tình và các di tích lịch sử tâm linh lâu đời.',
    imageUrl:
        'https://thungnham.com/wp-content/uploads/2024/03/khu-du-lich-trang-an-2.webp',
  ),
  Place(
    id: '14',
    name: 'Chùa Bái Đính',
    location: 'Ninh Bình',
    category: 'Văn hóa',
    rating: 4.6,
    reviewCount: 780,
    description:
        'Quần thể chùa Bái Đính là một trong những ngôi chùa lớn nhất Việt Nam với nhiều kỷ lục Châu Á và không gian tâm linh thanh bình.',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSTq45itqk6fs8IB15Hr59xE4ma-t9pvZyo0-MxltnDQ&s=10',
  ),
  Place(
    id: '15',
    name: 'Chợ Bến Thành',
    location: 'TP. Hồ Chí Minh',
    category: 'Văn hóa',
    rating: 4.5,
    reviewCount: 1100,
    description:
        'Biểu tượng lịch sử và văn hóa sôi động nằm tại trung tâm Sài Gòn, nơi giao thoa ẩm thực và mua sắm sầm uất.',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbg55D4tc1W9LgFyf78zwyUlReuWqus4jmsfmZfg51ww&s=10',
  ),
];
