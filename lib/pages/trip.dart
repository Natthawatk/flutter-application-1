import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/config/api_config.dart';
import 'package:flutter_application_1/model/response/trip_get_res.dart';

class TripPage extends StatefulWidget {
  final int idx;
  const TripPage({super.key, required this.idx});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  Trip? trip;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadTripDetail();
  }

  // ฟังก์ชันดึงรายละเอียดทริปจาก database
  Future<void> _loadTripDetail() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      log('🚀 Loading trip detail for idx: ${widget.idx}');
      final response = await http.get(
        Uri.parse(ApiConfig.tripDetailUrl(widget.idx)),
        headers: ApiConfig.headers,
      );

      log('📥 Trip detail response status: ${response.statusCode}');
      log('📥 Trip detail response body: ${response.body}');

      if (response.statusCode == 200) {
        final tripData = json.decode(response.body);
        trip = Trip.fromJson(tripData);
        log('✅ Loaded trip detail successfully: ${trip!.name}');
      } else {
        setState(() {
          errorMessage = 'ไม่สามารถโหลดรายละเอียดทริปได้: ${response.statusCode}';
        });
      }
    } catch (error) {
      log('❌ Error loading trip detail: $error');
      setState(() {
        errorMessage = 'เกิดข้อผิดพลาดในการเชื่อมต่อเซิร์ฟเวอร์';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trip?.name ?? 'รายละเอียดทริป'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? _buildErrorWidget()
              : trip != null
                  ? _buildTripDetailWidget()
                  : const Center(child: Text('ไม่พบข้อมูลทริป')),
    );
  }

  // Widget แสดงข้อผิดพลาด
  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              onPressed: _loadTripDetail,
              child: const Text('ลองใหม่'),
            ),
          ],
        ),
      ),
    );
  }

  // Widget แสดงรายละเอียดทริป
  Widget _buildTripDetailWidget() {
    const primaryColor = Color(0xFF8A5DB3);
    
    return RefreshIndicator(
      onRefresh: _loadTripDetail,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // รูปภาพหลัก
            _buildCoverImage(),
            
            // ข้อมูลพื้นฐาน
            _buildBasicInfo(primaryColor),
            
            // รายละเอียด
            _buildDetailSection(),
            
            // ปุ่มจอง
            _buildBookingButton(primaryColor),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Widget รูปภาพหลัก
  Widget _buildCoverImage() {
    return Container(
      width: double.infinity,
      height: 250,
      child: Image.network(
        trip!.coverimage,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[300],
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.broken_image, size: 64, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }

  // Widget ข้อมูลพื้นฐาน
  Widget _buildBasicInfo(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            trip!.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // ข้อมูลในรูปแบบ Card
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildInfoRow(Icons.public, 'ประเทศ', trip!.country),
                  const Divider(),
                  _buildInfoRow(Icons.calendar_today, 'ระยะเวลา', '${trip!.duration} วัน'),
                  const Divider(),
                  _buildInfoRow(Icons.attach_money, 'ราคา', '${trip!.price.toStringAsFixed(0)} บาท'),
                  const Divider(),
                  _buildInfoRow(Icons.location_on, 'ปลายทาง', trip!.destinationZone),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget แถวข้อมูล
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF8A5DB3), size: 24),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // Widget รายละเอียด
  Widget _buildDetailSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'รายละเอียดทริป',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                trip!.detail,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget ปุ่มจอง
  Widget _buildBookingButton(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            _showBookingConfirmation();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 3,
          ),
          child: Text(
            'จองทริปนี้ - ${trip!.price.toStringAsFixed(0)} บาท',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันแสดงการยืนยันการจอง
  void _showBookingConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการจอง'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('คุณต้องการจองทริป "${trip!.name}" หรือไม่?'),
              const SizedBox(height: 16),
              Text('ราคา: ${trip!.price.toStringAsFixed(0)} บาท'),
              Text('ระยะเวลา: ${trip!.duration} วัน'),
              Text('ประเทศ: ${trip!.country}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ยกเลิก'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                _processBooking();
              },
              child: const Text('ยืนยันการจอง'),
            ),
          ],
        );
      },
    );
  }

  // ฟังก์ชันประมวลผลการจอง
  void _processBooking() {
    // TODO: เพิ่มการเชื่อมต่อ API สำหรับจองทริป
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('จองทริป "${trip!.name}" สำเร็จ!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
    
    log('✅ Trip booking confirmed: ${trip!.name} (idx: ${trip!.idx})');
  }
}