import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

// API Key dự án của nhóm
const String googleApiKey = 'AIzaSyALKM5Q89C-0nUrkkXG-5xQbB5QcE2I6Tg';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  // Controllers cho ô nhập liệu
  final TextEditingController _originController = TextEditingController(text: 'Trường ĐH Công Thương TP.HCM');
  final TextEditingController _destinationController = TextEditingController(text: 'Chợ Bến Thành');

  // Trạng thái lộ trình
  String _selectedMode = 'driving'; // driving, motorcycle, walking
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  // Tọa độ đang được chọn để tìm đường
  LatLng _currentOrigin = const LatLng(10.8061, 106.6262);
  LatLng _currentDestination = const LatLng(10.7725, 106.6980);

  @override
  void initState() {
    super.initState();
    _setupInitialRoute();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _fitRoute();
  }

  // Khởi tạo Marker và gọi API vẽ đường ban đầu
  void _setupInitialRoute() {
    _updateMarkers();
    _fetchRoutePolyline();
  }

  // Cập nhật lại các điểm Marker trên bản đồ
  void _updateMarkers() {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('origin'),
          position: _currentOrigin,
          infoWindow: const InfoWindow(title: 'Điểm đi'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: _currentDestination,
          infoWindow: const InfoWindow(title: 'Điểm đến'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
  }

  // Hàm gọi Google Routes API và vẽ đường chi tiết
  Future<void> _fetchRoutePolyline() async {
    // Chuyển đổi phương tiện sang chuẩn của Routes API
    String routingPreferenceMode = 'DRIVE';
    if (_selectedMode == 'motorcycle') routingPreferenceMode = 'TWO_WHEELER';
    if (_selectedMode == 'walking') routingPreferenceMode = 'WALK';

    final url = Uri.parse('https://routes.googleapis.com/directions/v2:computeRoutes');

    final body = jsonEncode({
      "origin": {
        "location": {
          "latLng": {
            "latitude": _currentOrigin.latitude,
            "longitude": _currentOrigin.longitude,
          }
        }
      },
      "destination": {
        "location": {
          "latLng": {
            "latitude": _currentDestination.latitude,
            "longitude": _currentDestination.longitude,
          }
        }
      },
      "travelMode": routingPreferenceMode,
      "routingPreference": _selectedMode == 'walking' ? null : "TRAFFIC_AWARE",
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': googleApiKey,
          'X-Goog-FieldMask': 'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final encodedPolyline = data['routes'][0]['polyline']['encodedPolyline'];

          // Giải mã chuỗi polyline thành danh sách điểm
          final PolylinePoints polylinePoints = PolylinePoints(apiKey: googleApiKey);
          
          List<PointLatLng> decodedPoints = PolylinePoints.decodePolyline(encodedPolyline);

          List<LatLng> polylineCoordinates = decodedPoints
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();

          setState(() {
            _polylines.clear();
            _polylines.add(
              Polyline(
                polylineId: const PolylineId('real_route'),
                points: polylineCoordinates,
                color: const Color(0xFF0F766E), // Màu xanh Việt Đi
                width: 5,
                patterns: _selectedMode == 'walking' 
                    ? [PatternItem.dash(20), PatternItem.gap(10)] 
                    : [], // Đi bộ nét đứt, lái xe nét liền
              ),
            );
          });
          
          // Tự động chỉnh lại góc nhìn camera khi vẽ đường mới
          _fitRoute();
        }
      } else {
        debugPrint('Lỗi gọi Routes API: ${response.body}');
      }
    } catch (e) {
      debugPrint('Ngoại lệ khi gọi API: $e');
    }
  }

  // Chỉnh góc nhìn camera bao quát toàn bộ lộ trình
  void _fitRoute() {
    Future.delayed(const Duration(milliseconds: 500), () {
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          _currentDestination.latitude < _currentOrigin.latitude ? _currentDestination.latitude : _currentOrigin.latitude,
          _currentDestination.longitude < _currentOrigin.longitude ? _currentDestination.longitude : _currentOrigin.longitude,
        ),
        northeast: LatLng(
          _currentDestination.latitude > _currentOrigin.latitude ? _currentDestination.latitude : _currentOrigin.latitude,
          _currentDestination.longitude > _currentOrigin.longitude ? _currentDestination.longitude : _currentOrigin.longitude,
        ),
      );
      mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Lớp 1: Bản đồ Google Map
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _currentOrigin, zoom: 14.0),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),

          // Lớp 2: Bảng điều khiển tìm đường (Routing Panel)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header có nút Back
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Text('Chỉ đường', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      
                      // Thanh chọn phương tiện
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildTransportButton('driving', Icons.directions_car),
                            _buildTransportButton('motorcycle', Icons.two_wheeler),
                            _buildTransportButton('walking', Icons.directions_walk),
                          ],
                        ),
                      ),
                      const Divider(height: 24),

                      // Ô nhập Điểm đi và Điểm đến
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        child: Row(
                          children: [
                            // Cột icon chấm tròn và đường kẻ
                            Column(
                              children: [
                                const Icon(Icons.radio_button_checked, color: Colors.blue, size: 16),
                                Container(width: 2, height: 30, color: Colors.grey.shade300),
                                const Icon(Icons.location_on, color: Colors.red, size: 16),
                              ],
                            ),
                            const SizedBox(width: 12),
                            // Cột TextField
                            Expanded(
                              child: Column(
                                children: [
                                  TextField(
                                    controller: _originController,
                                    readOnly: true, // Tạm thời để readOnly vì chưa làm Google Places
                                    decoration: InputDecoration(
                                      hintText: 'Vị trí của bạn',
                                      filled: true,
                                      fillColor: Colors.grey.shade100,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: _destinationController,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      hintText: 'Chọn điểm đến',
                                      filled: true,
                                      fillColor: Colors.grey.shade100,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Nút hoán đổi vị trí
                            IconButton(
                              icon: const Icon(Icons.swap_vert),
                              onPressed: () {
                                // Đảo ngược text
                                String tempText = _originController.text;
                                _originController.text = _destinationController.text;
                                _destinationController.text = tempText;

                                // Đảo ngược tọa độ
                                LatLng tempLatLng = _currentOrigin;
                                _currentOrigin = _currentDestination;
                                _currentDestination = tempLatLng;

                                // Cập nhật marker và vẽ lại đường
                                _updateMarkers();
                                _fetchRoutePolyline();
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget nút chọn phương tiện
  Widget _buildTransportButton(String mode, IconData icon) {
    bool isSelected = _selectedMode == mode;
    return GestureDetector(
      onTap: () {
        if (_selectedMode != mode) {
          setState(() {
            _selectedMode = mode;
          });
          // Gọi API vẽ lại đường đi theo phương tiện mới
          _fetchRoutePolyline(); 
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F766E).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isSelected ? const Color(0xFF0F766E) : Colors.grey.shade600,
          size: 28,
        ),
      ),
    );
  }
}