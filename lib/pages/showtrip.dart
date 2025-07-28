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
import 'package:flutter_application_1/theme/app_theme.dart';
import 'package:flutter_application_1/widgets/animated_card.dart';
import 'package:flutter_application_1/widgets/travel_widgets.dart';

class ShowTripPage extends StatefulWidget {
  const ShowTripPage({super.key});

  @override
  State<ShowTripPage> createState() => _ShowTripPageState();
}

class _ShowTripPageState extends State<ShowTripPage> {
  // รายการหมวดหมู่ปลายทาง
  final List<String> destinations = [
    "All",
    "Asia",
    "Europe",
    "ASEAN",
    "America",
    "Africa"
  ];
  
  // หมวดหมู่ที่ถูกเลือกปัจจุบัน
  String selectedDestination = "All";
  
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
          errorMessage = 'Failed to load trips: ${response.statusCode}';
        });
      }
    } catch (error) {
      log('❌ Error loading trips: $error');
      setState(() {
        errorMessage = 'Connection error. Please check your internet.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // ฟังก์ชันกรองทริปตามปลายทาง
  void _filterTrips() {
    setState(() {
      if (selectedDestination == "All") {
        filteredTrips = trips;
      } else {
        // แปลงชื่อหมวดหมู่เป็นภาษาไทยสำหรับการเปรียบเทียบ
        String destinationInThai = _getDestinationInThai(selectedDestination);
        filteredTrips = trips.where((trip) {
          return trip.destinationZone.toLowerCase().contains(destinationInThai.toLowerCase()) ||
                 trip.destinationZone.toLowerCase().contains(selectedDestination.toLowerCase());
        }).toList();
      }
    });
    log('🔍 Filtered trips: ${filteredTrips.length} trips for $selectedDestination');
  }

  // ฟังก์ชันแปลงชื่อหมวดหมู่เป็นภาษาไทย
  String _getDestinationInThai(String englishDestination) {
    switch (englishDestination.toLowerCase()) {
      case 'asia':
        return 'เอเชีย';
      case 'europe':
        return 'ยุโรป';
      case 'asean':
        return 'อาเซียน';
      case 'america':
        return 'อเมริกา';
      case 'africa':
        return 'แอฟริกา';
      default:
        return englishDestination;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadTrips,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: TravelHeader(
                  greeting: 'Hello, ${UserSession.currentUserName ?? 'Traveler'}',
                  subtitle: 'Discover amazing destinations',
                  avatarUrl: UserSession.currentUserImage,
                  onMenuTap: _showMenuOptions,
                  onAvatarTap: () => _navigateToProfile(),
                ),
              ),
              
              // Search Bar
              const SliverToBoxAdapter(
                child: TravelSearchBar(
                  hintText: 'Search destinations...',
                ),
              ),
              
              // Category Tabs
              SliverToBoxAdapter(
                child: CategoryTabs(
                  categories: destinations,
                  selectedCategory: selectedDestination,
                  onCategorySelected: (category) {
                    setState(() {
                      selectedDestination = category;
                      _filterTrips();
                    });
                  },
                ),
              ),
              
              // Content
              if (isLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryBlack,
                    ),
                  ),
                )
              else if (errorMessage.isNotEmpty)
                SliverFillRemaining(
                  child: _buildErrorState(),
                )
              else if (filteredTrips.isEmpty)
                SliverFillRemaining(
                  child: _buildEmptyState(),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final trip = filteredTrips[index];
                      return SlideInAnimation(
                        delay: Duration(milliseconds: 100 * index),
                        child: DestinationCard(
                          title: trip.name,
                          location: trip.country,
                          imageUrl: trip.coverimage,
                          rating: 4.5, // Default rating since not in model
                          reviewCount: 128, // Default review count
                          onTap: () => _navigateToTripDetail(trip.idx),
                          onFavorite: () => _toggleFavorite(trip.idx),
                        ),
                      );
                    },
                    childCount: filteredTrips.length,
                  ),
                ),
              
              // Bottom spacing
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xl),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.error_outline,
                size: 60,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Oops! Something went wrong',
              style: AppTheme.headingSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              errorMessage,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              text: 'Try Again',
              onPressed: _loadTrips,
              icon: Icons.refresh,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.travel_explore,
                size: 60,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No trips found',
              style: AppTheme.headingSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'No trips available in "$selectedDestination" category',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showMenuOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.primaryWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: AppTheme.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                _navigateToProfile();
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showLogoutConfirmation();
              },
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  void _navigateToTripDetail(int tripId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TripPage(idx: tripId)),
    );
  }

  void _toggleFavorite(int tripId) {
    // TODO: Implement favorite functionality
    log('Toggle favorite for trip: $tripId');
  }

  // ฟังก์ชันแสดงการยืนยัน logout
  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: AppTheme.radiusLarge,
          ),
          title: const Row(
            children: [
              Icon(Icons.logout, color: Colors.orange),
              SizedBox(width: 8),
              Text('Logout'),
            ],
          ),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text('Logout'),
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
        content: Text('Logged out successfully'),
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