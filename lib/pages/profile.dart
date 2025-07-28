import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/config/api_config.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:flutter_application_1/utils/user_session.dart';

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
      appBar: AppBar(
        title: const Text('ข้อมูลส่วนตัว'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'logout') {
                _showLogoutConfirmation();
              } else if (value == 'delete') {
                _showDeleteAccountConfirmation();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('ออกจากระบบ'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_forever, color: Colors.red),
                    SizedBox(width: 8),
                    Text('ยกเลิกสมาชิก', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? _buildErrorWidget()
              : _buildProfileForm(),
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
              onPressed: _loadUserProfile,
              child: const Text('ลองใหม่'),
            ),
          ],
        ),
      ),
    );
  }

  // Widget ฟอร์มแก้ไขข้อมูล
  Widget _buildProfileForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // รูปโปรไฟล์
            _buildProfileImage(),
            const SizedBox(height: 24),
            
            // ฟอร์มข้อมูล
            _buildFormFields(),
            
            const SizedBox(height: 32),
            
            // ปุ่มบันทึก
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  // Widget รูปโปรไฟล์
  Widget _buildProfileImage() {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: 2),
          ),
          child: ClipOval(
            child: _imageController.text.isNotEmpty
                ? Image.network(
                    _imageController.text,
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
                        child: const Icon(Icons.person, size: 60, color: Colors.grey),
                      );
                    },
                  )
                : Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, size: 60, color: Colors.grey),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'รูปโปรไฟล์',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
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
        const Text(
          'ชื่อ-นามสกุล',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _fullNameController,
          decoration: const InputDecoration(
            hintText: 'กรอกชื่อ-นามสกุล',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'กรุณากรอกชื่อ-นามสกุล';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // หมายเลขโทรศัพท์
        const Text(
          'หมายเลขโทรศัพท์',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            hintText: 'กรอกหมายเลขโทรศัพท์',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'กรุณากรอกหมายเลขโทรศัพท์';
            }
            if (value.length < 10) {
              return 'หมายเลขโทรศัพท์ต้องมีอย่างน้อย 10 หลัก';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // อีเมล์
        const Text(
          'อีเมล์',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            hintText: 'กรอกที่อยู่อีเมล์',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'กรุณากรอกอีเมล์';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'รูปแบบอีเมล์ไม่ถูกต้อง';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // URL รูปภาพ
        const Text(
          'URL รูปภาพ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _imageController,
          decoration: const InputDecoration(
            hintText: 'กรอก URL รูปภาพ (ไม่บังคับ)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.image),
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
                return 'รูปแบบ URL ไม่ถูกต้อง';
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
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isSaving ? null : _saveUserProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8A5DB3),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: isSaving
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text('กำลังบันทึก...'),
                ],
              )
            : const Text(
                'บันทึกข้อมูล',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  // ฟังก์ชันแสดงการยืนยันลบบัญชี
  void _showDeleteAccountConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 8),
              Text('ยกเลิกสมาชิก'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('⚠️ การดำเนินการนี้ไม่สามารถย้อนกลับได้'),
              SizedBox(height: 8),
              Text('ข้อมูลทั้งหมดของคุณจะถูกลบออกจากระบบ'),
              SizedBox(height: 8),
              Text('คุณแน่ใจหรือไม่ที่ต้องการยกเลิกสมาชิก?'),
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
                _performDeleteAccount();
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('ยืนยันการลบ'),
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
            content: Text('ยกเลิกสมาชิกสำเร็จ'),
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