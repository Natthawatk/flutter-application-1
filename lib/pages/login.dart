import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/register.dart';
import 'package:flutter_application_1/pages/showtrip.dart';
import 'package:flutter_application_1/model/request/customer_login_post_req.dart';
import 'package:flutter_application_1/model/response/customer_login_post_res.dart';
import 'package:flutter_application_1/config/api_config.dart';
import 'package:flutter_application_1/utils/user_session.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';
  
  // Pre-defined credentials
  final String correctPhone = '0812345678';
  final String correctPassword = '1234';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: InkWell(
                child: Image.asset(
                  'assets/images/travel-logo.jpg',
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('หมายเลขโทรศัพท์'),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      hintText: 'ใส่หมายเลขโทรศัพท์',
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  const Text('รหัสผ่าน'),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      hintText: 'ใส่รหัสผ่าน',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  // Error message display
                  if (errorMessage.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        border: Border.all(color: Colors.red.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              errorMessage,
                              style: TextStyle(color: Colors.red.shade600, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: register,
                        child: const Text('ลงทะเบียนใหม่'),
                      ),
                      FilledButton(
                        onPressed: () => login(phoneController.text, passwordController.text),
                        child: const Text('เข้าสู่ระบบ'),
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

// Process
  void register() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterPage()));
  }

  void login(String phone, String password) async {
    setState(() {
      errorMessage = '';
    });

    // Validate fields are not empty
    if (phone.trim().isEmpty || password.trim().isEmpty) {
      setState(() {
        errorMessage = 'กรุณากรอกหมายเลขโทรศัพท์และรหัสผ่าน';
      });
      return;
    }

    try {
      // Create request object
      CustomerLoginPostRequest req = CustomerLoginPostRequest(
        phone: phone.trim(),
        password: password,
      );

      // Make API call
      final response = await http.post(
        Uri.parse(ApiConfig.loginUrl),
        headers: ApiConfig.headers,
        body: customerLoginPostRequestToJson(req),
      );

      log('Login response status: ${response.statusCode}');
      log('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        CustomerLoginPostResponse loginResponse =
            customerLoginPostResponseFromJson(response.body);
        
        log('Login successful for: ${loginResponse.customer.fullname}');
        
        // เก็บ user session
        UserSession.setUserSession(
          userId: loginResponse.customer.idx,
          userName: loginResponse.customer.fullname,
          userPhone: loginResponse.customer.phone,
          userEmail: loginResponse.customer.email,
          userImage: loginResponse.customer.image,
        );
        
        // Navigate to ShowTripPage on successful login
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => ShowTripPage())
        );
      } else if (response.statusCode == 401) {
        setState(() {
          errorMessage = 'หมายเลขโทรศัพท์หรือรหัสผ่านไม่ถูกต้อง';
        });
      } else if (response.statusCode == 404) {
        setState(() {
          errorMessage = 'ไม่พบผู้ใช้งานในระบบ';
        });
      } else {
        setState(() {
          errorMessage = 'เกิดข้อผิดพลาดในการเข้าสู่ระบบ';
        });
      }
    } catch (error) {
      log('Login error: $error');
      setState(() {
        errorMessage = 'เกิดข้อผิดพลาดในการเชื่อมต่อเซิร์ฟเวอร์';
      });
    }
  }
}
