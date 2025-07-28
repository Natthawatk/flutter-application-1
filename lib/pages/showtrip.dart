import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/config/api_config.dart';
import 'package:flutter_application_1/model/response/trip_get_res.dart';
import 'package:flutter_application_1/pages/trip.dart';
import 'package:flutter_application_1/pages/profile.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:flutter_application_1/utils/user_session.dart';

class ShowTripPage extends StatefulWidget {
  const ShowTripPage({super.key});

  @override
  State<ShowTripPage> createState() => _ShowTripPageState();
}

class _ShowTripPageState extends State<ShowTripPage> {
  // รายการหมวดหมู่ปลายทาง
  final List<String> destinations = [
    "ทั้งหมด",
    "เอเชีย",
    "ยุโรป",
    "อาเซียน",
    "อเมริกา",
    "แอฟริกา"
  ];
  // หมวดหมู่ที่ถูกเลือกปัจจุบัน
  String selectedDestination = "ทั้งหมด";
  
  // ข้อมูลทริปจาก database
  List<Trip> trips = [];
  List<Trip> filteredTrips = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  // ฟังก์ชันดึงข้อมูลทริปจาก database
  Future<void> _loadTrips() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      log('🚀 Loading trips from database...');
      final response = await http.get(
        Uri.parse(ApiConfig.tripsUrl),
        headers: ApiConfig.headers,
      );

      log('📥 Trips response status: ${response.statusCode}');
      log('📥 Trips response body: ${response.body}');

      if (response.statusCode == 200) {
        trips = tripGetResponseFromJson(response.body);
        _filterTrips();
        log('✅ Loaded ${trips.length} trips successfully');
      } else {
        setState(() {
          errorMessage = 'ไม่สามารถโหลดข้อมูลทริปได้: ${response.statusCode}';
        });
      }
    } catch (error) {
      log('❌ Error loading trips: $error');
      setState(() {
        errorMessage = 'เกิดข้อผิดพลาดในการเชื่อมต่อเซิร์ฟเวอร์';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // ฟังก์ชันกรองทริปตามปลายทาง
  void _filterTrips() {
    if (selectedDestination == "ทั้งหมด") {
      filteredTrips = trips;
    } else {
      filteredTrips = trips.where((trip) => 
        trip.destinationZone.toLowerCase() == selectedDestination.toLowerCase()
      ).toList();
    }
    log('🔍 Filtered trips: ${filteredTrips.length} trips for $selectedDestination');
  }

  @override
  Widget build(BuildContext context) {
    // สีหลักที่ใช้ในดีไซน์
    const primaryColor = Color(0xFF8A5DB3);
    const cardBackgroundColor = Color(0xFFF8F5FA);
    const screenBackgroundColor = Color(0xFFFFFFFF);

    return Scaffold(
      backgroundColor: screenBackgroundColor,
      appBar: AppBar(
        title: const Text('รายการทริป'),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              } else if (value == 'logout') {
                _showLogoutConfirmation();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadTrips,
        child: SingleChildScrollView(
          // ทำให้ทั้งหน้าจอสามารถเลื่อนได้ในแนวตั้ง
          physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              // ส่วนหัวข้อ "ปลายทาง" และปุ่ม Filter
              _buildDestinationFilter(primaryColor),

              const SizedBox(height: 16),

              // แสดงสถานะการโหลดหรือข้อผิดพลาด
              if (isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (errorMessage.isNotEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                        const SizedBox(height: 16),
                        Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red.shade600),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadTrips,
                          child: const Text('ลองใหม่'),
                        ),
                      ],
                    ),
                  ),
                )
              else if (filteredTrips.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(Icons.travel_explore, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          'ไม่พบทริปในหมวดหมู่ "$selectedDestination"',
                          style: TextStyle(color: Colors.grey.shade600),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                // รายการการ์ดทริปจาก database
                ...filteredTrips.map((trip) => _buildTripCard(
                  trip: trip,
                  primaryColor: primaryColor,
                  cardBackgroundColor: cardBackgroundColor,
                )),
                ],
              ),
            ),
          ),
        ),
    );
  }

  /// Widget สำหรับสร้างส่วน Filter ปลายทาง
  Widget _buildDestinationFilter(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ปลายทาง',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Widget ที่ทำให้ List สามารถเลื่อนแนวนอนได้
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                final destination = destinations[index];
                final isSelected = destination == selectedDestination;
                return Padding(
                  padding:
                      EdgeInsets.only(right: 8.0, left: index == 0 ? 0 : 0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedDestination = destination;
                        _filterTrips();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isSelected ? primaryColor : const Color(0xFFEAEAEA),
                      foregroundColor: isSelected ? Colors.white : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: Text(destination),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Widget สำหรับสร้างการ์ดทริปแต่ละใบ
  Widget _buildTripCard({
    required Trip trip,
    required Color primaryColor,
    required Color cardBackgroundColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            trip.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            color: cardBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // รูปภาพ
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      trip.coverimage,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 120,
                          height: 120,
                          color: Colors.grey[300],
                          child:
                              const Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 120,
                          height: 120,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image,
                              color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // รายละเอียดทริป
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.country,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text('ระยะเวลา ${trip.duration} วัน',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text('ราคา ${trip.price.toStringAsFixed(0)} บาท',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey)),

                        // เว้นระยะห่างก่อนถึงปุ่ม
                        const SizedBox(height: 8),

                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            onPressed: () {
                            // Navigate ไปหน้ารายละเอียดทริป
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TripPage(idx: trip.idx),
                              ),
                            );
                          },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('รายละเอียดเพิ่มเติม'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ฟังก์ชันแสดงการยืนยัน logout
  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.logout, color: Colors.orange),
              SizedBox(width: 8),
              Text('ออกจากระบบ'),
            ],
          ),
          content: const Text('คุณต้องการออกจากระบบหรือไม่?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ยกเลิก'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout();
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text('ออกจากระบบ'),
            ),
          ],
        );
      },
    );
  }

  // ฟังก์ชันดำเนินการ logout
  void _performLogout() {
    log('🚪 User logged out from ShowTrip');
    
    // ล้าง user session
    UserSession.clearUserSession();
    
    // แสดงข้อความ
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('ออกจากระบบสำเร็จ'),
        backgroundColor: Colors.orange,
      ),
    );
    
    // กลับไปหน้า login โดยแทนที่ทั้ง navigation stack
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }
}
