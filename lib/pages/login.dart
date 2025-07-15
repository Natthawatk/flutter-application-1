import 'dart:developer';

import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: login,
                child: Image.asset(
                  'assets/images/travel-logo.jpg',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              const Text('หมายเลขโทรศัพท์',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
              const SizedBox(height: 8),
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('รหัสผ่าน',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
              const SizedBox(height: 8),
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () { 
                        login(); },
                      child: const Text('ลงทะเบียนใหม่')),
                  FilledButton(
                      onPressed: () {}, child: const Text('เข้าสู่ระบบ')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


// Process
  void login() {
    // Dart
    log('Hello world');
  }
}
