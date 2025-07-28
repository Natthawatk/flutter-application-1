import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/config/api_config.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:flutter_application_1/utils/user_session.dart';
import 'package:flutter_application_1/theme/app_theme.dart';
import 'package:flutter_application_1/widgets/animated_card.dart';
import 'package:flutter_application_1/widgets/travel_widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  bool isLoading = true;
  bool isSaving = false;
  String errorMessage = '';
  int? currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  // ฟังก์ชันดึงข้อมูลผู้ใช้ปัจจุบัน
  Future<void> _loadUserProfile() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      // ใช้ user id จาก session
      currentUserId = UserSession.currentUserId ?? 1; // fallback เป็น 1 ถ้าไม่มี session
      
      log('🚀 Loading user profile for id: $currentUserId');
      final response = await http.get(
        Uri.parse(ApiConfig.customerDetailUrl(currentUserId!)),
        headers: ApiConfig.headers,
      );

      log('📥 Profile response status: ${response.statusCode}');
      log('📥 Profile response body: ${response.body}');

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        
        // เติมข้อมูลลงใน form
        _fullNameController.text = userData['fullname'] ?? '';
        _phoneController.text = userData['phone'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _imageController.text = userData['image'] ?? '';
        
        log('✅ Loaded user profile successfully: ${userData['fullname']}');
      } else {
        setState(() {
          errorMessage = 'ไม่สามารถโหลดข้อมูลผู้ใช้ได้: ${response.statusCode}';
        });
      }
    } catch (error) {
      log('❌ Error loading user profile: $error');
      setState(() {
        errorMessage = 'เกิดข้อผิดพลาดในการเชื่อมต่อเซิร์ฟเวอร์';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // ฟังก์ชันบันทึกข้อมูลผู้ใช้
  Future<void> _saveUserProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() {
        isSaving = true;
      });

      final updateData = {
        'fullname': _fullNameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'image': _imageController.text.trim().isEmpty 
            ? ApiConfig.defaultImageUrl 
            : _imageController.text.trim(),
      };

      log('📤 Updating user profile: ${json.encode(updateData)}');
      final response = await http.put(
        Uri.parse(ApiConfig.customerDetailUrl(currentUserId!)),
        headers: ApiConfig.headers,
        body: json.encode(updateData),
      );

      log('📥 Update response status: ${response.statusCode}');
      log('📥 Update response body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('บันทึกข้อมูลสำเร็จ!'),
            backgroundColor: Colors.green,
          ),
        );
        log('✅ Profile updated successfully');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      log('❌ Error updating profile: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('เกิดข้อผิดพลาดในการเชื่อมต่อเซิร์ฟเวอร์'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primaryBlack,
                ),
              )
            : errorMessage.isNotEmpty
                ? _buildErrorWidget()
                : _buildProfileContent(),
      ),
    );
  }

  // Widget แสดงข้อผิดพลาด
  Widget _buildErrorWidget() {
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
              onPressed: _loadUserProfile,
              icon: Icons.refresh,
            ),
          ],
        ),
      ),
    );
  }

  // Widget เนื้อหาโปรไฟล์
  Widget _buildProfileContent() {
    return CustomScrollView(
      slivers: [
        // Header with menu
        SliverToBoxAdapter(
          child: _buildProfileHeader(),
        ),
        
        // Profile Image and Info
        SliverToBoxAdapter(
          child: _buildProfileImageSection(),
        ),
        
        // Form Fields
        SliverToBoxAdapter(
          child: _buildProfileForm(),
        ),
        
        // Save Button
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: _buildSaveButton(),
          ),
        ),
        
        // Bottom spacing
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.xl),
        ),
      ],
    );
  }

  // Widget header โปรไฟล์
  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          Expanded(
            child: Text(
              'Profile',
              style: AppTheme.headingMedium,
              textAlign: TextAlign.center,
            ),
          ),
          // Menu button
          GestureDetector(
            onTap: _showMenuOptions,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppTheme.primaryBlack,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.more_vert,
                color: AppTheme.primaryWhite,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget ส่วนรูปโปรไฟล์
  Widget _buildProfileImageSection() {
    return FadeInAnimation(
      delay: const Duration(milliseconds: 200),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            _buildProfileImage(),
            const SizedBox(height: AppSpacing.md),
            Text(
              UserSession.currentUserName ?? 'User',
              style: AppTheme.headingSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              UserSession.currentUserEmail ?? 'user@example.com',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget ฟอร์มแก้ไขข้อมูล
  Widget _buildProfileForm() {
    return SlideInAnimation(
      delay: const Duration(milliseconds: 400),
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.md),
        child: AnimatedCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personal Information',
                  style: AppTheme.headingSmall,
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildFormFields(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget รูปโปรไฟล์
  Widget _buildProfileImage() {
    return Stack(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppTheme.primaryGradient,
            boxShadow: const [AppTheme.cardShadow],
          ),
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryWhite,
            ),
            child: ClipOval(
              child: _imageController.text.isNotEmpty
                  ? Image.network(
                      _imageController.text,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: AppTheme.lightGray,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.primaryBlack,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppTheme.lightGray,
                          child: const Icon(
                            Icons.person,
                            size: 60,
                            color: AppTheme.textSecondary,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: AppTheme.lightGray,
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: AppTheme.textSecondary,
                      ),
                    ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppTheme.primaryBlack,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt,
              color: AppTheme.primaryWhite,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }

  // Widget ฟิลด์ฟอร์ม
  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ชื่อ-นามสกุล
        Text(
          'Full Name',
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: _fullNameController,
          decoration: const InputDecoration(
            hintText: 'Enter your full name',
            prefixIcon: Icon(
              Icons.person_outline,
              color: AppTheme.textSecondary,
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your full name';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.md),

        // หมายเลขโทรศัพท์
        Text(
          'Phone Number',
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            hintText: 'Enter your phone number',
            prefixIcon: Icon(
              Icons.phone_outlined,
              color: AppTheme.textSecondary,
            ),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your phone number';
            }
            if (value.length < 10) {
              return 'Phone number must be at least 10 digits';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.md),

        // อีเมล์
        Text(
          'Email',
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            hintText: 'Enter your email',
            prefixIcon: Icon(
              Icons.email_outlined,
              color: AppTheme.textSecondary,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.md),

        // URL รูปภาพ
        Text(
          'Profile Image URL',
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: _imageController,
          decoration: const InputDecoration(
            hintText: 'Enter image URL (optional)',
            prefixIcon: Icon(
              Icons.image_outlined,
              color: AppTheme.textSecondary,
            ),
          ),
          keyboardType: TextInputType.url,
          onChanged: (value) {
            // อัปเดตรูปภาพเมื่อ URL เปลี่ยน
            setState(() {});
          },
          validator: (value) {
            if (value != null && value.trim().isNotEmpty) {
              final uri = Uri.tryParse(value);
              if (uri == null || !uri.hasAbsolutePath) {
                return 'Please enter a valid URL';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  // Widget ปุ่มบันทึก
  Widget _buildSaveButton() {
    return PrimaryButton(
      text: 'Save Changes',
      isLoading: isSaving,
      icon: Icons.save,
      onPressed: _saveUserProfile,
    );
  }

  // แสดงเมนูตัวเลือก
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
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit Profile'),
              onTap: () {
                Navigator.pop(context);
                // Focus on first field for editing
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.orange),
              title: const Text('Logout', style: TextStyle(color: Colors.orange)),
              onTap: () {
                Navigator.pop(context);
                _showLogoutConfirmation();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteAccountConfirmation();
              },
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
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

  // ฟังก์ชันแสดงการยืนยันลบบัญชี
  void _showDeleteAccountConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: AppTheme.radiusLarge,
          ),
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete Account'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('⚠️ This action cannot be undone'),
              SizedBox(height: 8),
              Text('All your data will be permanently deleted'),
              SizedBox(height: 8),
              Text('Are you sure you want to delete your account?'),
            ],
          ),
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
                _performDeleteAccount();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // ฟังก์ชันดำเนินการ logout
  void _performLogout() {
    log('🚪 User logged out from Profile');
    
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

  // ฟังก์ชันดำเนินการลบบัญชี
  Future<void> _performDeleteAccount() async {
    try {
      setState(() {
        isSaving = true;
      });

      log('🗑️ Deleting user account: $currentUserId');
      final response = await http.delete(
        Uri.parse(ApiConfig.customerDetailUrl(currentUserId!)),
        headers: ApiConfig.headers,
      );

      log('📥 Delete response status: ${response.statusCode}');
      log('📥 Delete response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        log('✅ Account deleted successfully');
        
        // แสดงข้อความสำเร็จ
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        
        // รอ 1 วินาทีแล้วกลับไปหน้า login
        await Future.delayed(const Duration(seconds: 1));
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
        );
        
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาดในการลบบัญชี: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      log('❌ Error deleting account: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('เกิดข้อผิดพลาดในการเชื่อมต่อเซิร์ฟเวอร์'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }
}