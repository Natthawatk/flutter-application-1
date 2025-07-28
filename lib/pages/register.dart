import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/model/request/customer_register_post_req.dart';
import 'package:flutter_application_1/model/response/customer_register_post_res.dart';
import 'package:flutter_application_1/config/api_config.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _imageController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ลงทะเบียนสมาชิกใหม่'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 0),
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
                controller: _phoneNumberController,
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
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
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
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    // Basic URL validation
                    final uri = Uri.tryParse(value);
                    if (uri == null || !uri.hasAbsolutePath) {
                      return 'รูปแบบ URL ไม่ถูกต้อง';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // รหัสผ่าน
              const Text(
                'รหัสผ่าน',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'กรอกรหัสผ่าน',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกรหัสผ่าน';
                  }
                  if (value.length < 6) {
                    return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ยืนยันรหัสผ่าน
              const Text(
                'ยืนยันรหัสผ่าน',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  hintText: 'ยืนยันรหัสผ่าน',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isConfirmPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณายืนยันรหัสผ่าน';
                  }
                  if (value != _passwordController.text) {
                    return 'รหัสผ่านไม่ตรงกัน';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // ปุ่มสมัครสมาชิก
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _submitForm,
                  child: const Text(
                    'สมัครสมาชิก',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Advanced Option Button
              Center(
                child: TextButton.icon(
                  onPressed: _showAdvancedUserInfo,
                  icon: Icon(Icons.info_outline, size: 18),
                  label: Text('ข้อมูลระบบ (Advanced)'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue.shade600,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Secondary Action
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('หากมีบัญชีอยู่แล้ว? '),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('เข้าสู่ระบบ'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _registerCustomer();
    }
  }

  void _registerCustomer() async {
    // Additional validation - Required fields must not be empty
    if (_fullNameController.text.trim().isEmpty ||
        _phoneNumberController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณากรอกข้อมูลให้ครบทุกช่อง (ยกเว้น URL รูปภาพ)'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check password and confirm password match
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('รหัสผ่านและยืนยันรหัสผ่านไม่ตรงกัน'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      log('🚀 Starting registration process...');

      // Create request object
      String imageUrl = _imageController.text.trim().isEmpty 
          ? ApiConfig.defaultImageUrl 
          : _imageController.text.trim();
          
      CustomerRegisterPostRequest req = CustomerRegisterPostRequest(
        fullname: _fullNameController.text.trim(),
        phone: _phoneNumberController.text.trim(),
        email: _emailController.text.trim(),
        image: imageUrl,
        password: _passwordController.text,
      );

      log('📤 Sending registration request...');
      log('📋 Request data: ${customerRegisterPostRequestToJson(req)}');

      // Make API call to create new user
      final response = await http.post(
        Uri.parse(ApiConfig.customersUrl),
        headers: ApiConfig.headers,
        body: customerRegisterPostRequestToJson(req),
      );

      log('📥 Response status: ${response.statusCode}');
      log('📥 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          CustomerRegisterPostResponse registerResponse =
              customerRegisterPostResponseFromJson(response.body);
          
          log('✅ Registration successful for: ${registerResponse.customer.fullname}');
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('สมัครสมาชิกสำเร็จ! กรุณาเข้าสู่ระบบ'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pop(context);
        } catch (parseError) {
          log('⚠️ Response parsing error: $parseError');
          // Even if parsing fails, if status is 200/201, consider it success
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('สมัครสมาชิกสำเร็จ! กรุณาเข้าสู่ระบบ'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } else if (response.statusCode == 409 || response.statusCode == 400) {
        // Handle duplicate user or bad request
        String errorMessage = 'หมายเลขโทรศัพท์หรืออีเมลนี้ถูกใช้งานแล้ว';
        
        try {
          final errorData = json.decode(response.body);
          if (errorData['message'] != null) {
            errorMessage = errorData['message'];
          }
        } catch (e) {
          log('Could not parse error message: $e');
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: ${response.statusCode} - ${response.body}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      log('❌ Registration error: $error');
      
      String errorMessage = 'เกิดข้อผิดพลาดในการเชื่อมต่อเซิร์ฟเวอร์';
      
      // Check if it's a network error
      if (error.toString().contains('SocketException') || 
          error.toString().contains('Connection refused')) {
        errorMessage = 'ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้ กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ต';
      } else if (error.toString().contains('TimeoutException')) {
        errorMessage = 'การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง';
      } else if (error.toString().contains('FormatException')) {
        errorMessage = 'ข้อมูลที่ได้รับจากเซิร์ฟเวอร์ไม่ถูกต้อง';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  // ADVANCED FUNCTIONS: Check existing users in database (Optional - fallback to server validation)
  Future<bool> _checkPhoneExists(String phone) async {
    try {
      log('🔍 Checking phone number: $phone');
      // Try different possible endpoints
      final endpoints = [
        ApiConfig.checkPhoneUrl(phone),
        ApiConfig.customersPhoneUrl(phone),
        ApiConfig.customersQueryPhoneUrl(phone)
      ];
      
      for (String endpoint in endpoints) {
        try {
          final response = await http.get(
            Uri.parse(endpoint),
            headers: ApiConfig.headers,
          ).timeout(Duration(seconds: 5));
          
          log('📱 Phone check response from $endpoint: ${response.statusCode}');
          if (response.statusCode == 200) {
            return true;
          }
        } catch (e) {
          log('Endpoint $endpoint failed: $e');
          continue;
        }
      }
      
      return false;
    } catch (error) {
      log('❌ Error checking phone: $error');
      return false; // If check fails, proceed with registration (server will handle duplicates)
    }
  }

  Future<bool> _checkEmailExists(String email) async {
    try {
      log('🔍 Checking email: $email');
      // Try different possible endpoints
      final endpoints = [
        ApiConfig.checkEmailUrl(email),
        ApiConfig.customersEmailUrl(email),
        ApiConfig.customersQueryEmailUrl(email)
      ];
      
      for (String endpoint in endpoints) {
        try {
          final response = await http.get(
            Uri.parse(endpoint),
            headers: ApiConfig.headers,
          ).timeout(Duration(seconds: 5));
          
          log('📧 Email check response from $endpoint: ${response.statusCode}');
          if (response.statusCode == 200) {
            return true;
          }
        } catch (e) {
          log('Endpoint $endpoint failed: $e');
          continue;
        }
      }
      
      return false;
    } catch (error) {
      log('❌ Error checking email: $error');
      return false; // If check fails, proceed with registration (server will handle duplicates)
    }
  }

  void _showUserExistsDialog(String fieldType, String value) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
              SizedBox(width: 8),
              Text('ผู้ใช้งานมีอยู่แล้ว'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$fieldType: $value ถูกใช้งานแล้วในระบบ'),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Colors.blue.shade600, size: 20),
                        SizedBox(width: 8),
                        Text('คำแนะนำ:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade600)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text('• ลองใช้$fieldTypeอื่น'),
                    Text('• หากเป็นบัญชีของคุณ ให้เข้าสู่ระบบแทน'),
                    Text('• ติดต่อผู้ดูแลระบบหากมีปัญหา'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('ตกลง'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to login
              },
              child: Text('เข้าสู่ระบบ'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAdvancedUserInfo() async {
    try {
      // Try to get users count for advanced info
      final endpoints = [
        ApiConfig.customersCountUrl,
        ApiConfig.customersUrl
      ];
      
      int userCount = 0;
      bool success = false;
      
      for (String endpoint in endpoints) {
        try {
          final response = await http.get(
            Uri.parse(endpoint),
            headers: ApiConfig.headers,
          ).timeout(Duration(seconds: 5));
          
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            if (endpoint.contains('/count')) {
              userCount = data['count'] ?? 0;
            } else {
              // If it's a list of customers, count them
              if (data is List) {
                userCount = data.length;
              } else if (data['customers'] is List) {
                userCount = data['customers'].length;
              }
            }
            success = true;
            break;
          }
        } catch (e) {
          log('Endpoint $endpoint failed: $e');
          continue;
        }
      }
      
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue),
                SizedBox(width: 8),
                Text('ข้อมูลระบบ'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (success) ...[
                  Text('จำนวนผู้ใช้งานในระบบ: $userCount คน'),
                  SizedBox(height: 16),
                ] else ...[
                  Text('ไม่สามารถดึงข้อมูลจำนวนผู้ใช้งานได้'),
                  SizedBox(height: 16),
                ],
                Text('เซิร์ฟเวอร์: ${ApiConfig.baseUrl}'),
                SizedBox(height: 8),
                Text('ระบบจะตรวจสอบข้อมูลซ้ำอัตโนมัติ'),
                SizedBox(height: 8),
                Text('สถานะ: ${success ? "เชื่อมต่อได้" : "เชื่อมต่อไม่ได้"}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('ตกลง'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      log('Error getting user info: $error');
      
      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red),
                SizedBox(width: 8),
                Text('ข้อผิดพลาด'),
              ],
            ),
            content: Text('ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้\nกรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ต'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('ตกลง'),
              ),
            ],
          );
        },
      );
    }
  }
}
